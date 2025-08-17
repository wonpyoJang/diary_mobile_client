import 'dart:io';

import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/dtos/media_info_dto.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_local_provider.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IWriteMomentLocalProvider)
class WriteMomentLocalProvider implements IWriteMomentLocalProvider {
  final DriftClient _driftClient;

  WriteMomentLocalProvider(this._driftClient);

  /// [DEPRECATED] 트랜잭션 분리로 인해 더 이상 사용하지 않음
  @override
  Future<Either<LocalFailure, Unit>> saveMoment(MomentDto moment) async {
    // 더 이상 사용하지 않음
    throw UnimplementedError('saveMoment는 deprecated 되었습니다.');
  }

  /// moment만 저장
  @override
  Future<Either<LocalFailure, Unit>> saveMomentOnly(MomentDto moment) async {
    return await _driftClient.runQuery<Unit>((db) async {
      await db.into(db.momentTable).insertOnConflictUpdate(
            MomentTableCompanion.insert(
              id: moment.id,
              reflection: moment.reflection,
              date: DateTime.parse(moment.date),
              modifiedAt: DateTime.parse(moment.modifiedAt),
            ),
          );
      return unit;
    }, description: 'saveMomentOnly');
  }

  /// intensity만 저장
  @override
  Future<Either<LocalFailure, Unit>> saveEmotionalIntensities(
      String momentId, List<EmotionalIntensityDto> intensities) async {
    return await _driftClient.runQuery<Unit>((db) async {
      for (final emotionalIntensity in intensities) {
        await db.into(db.emotionalIntensityTable).insert(
              EmotionalIntensityTableCompanion.insert(
                id: '${momentId}_${emotionalIntensity.emotion}',
                emotion: Emotion.findByName(emotionalIntensity.emotion),
                intensity: emotionalIntensity.intensity,
                momentId: momentId,
              ),
            );
      }
      return unit;
    }, description: 'saveEmotionalIntensities');
  }

  @override
  Future<Either<LocalFailure, Unit>> saveMedia(
    String momentId,
    List<String> mediaPaths,
  ) async {
    return await _driftClient.runQuery<Unit>((db) async {
      for (final path in mediaPaths) {
        final file = File(path);
        if (!await file.exists()) {
          throw LocalFailure(
            message: '파일을 찾을 수 없습니다.',
            code: 'FILE_NOT_FOUND',
            details: {'path': path},
          );
        }

        final bytes = await file.readAsBytes();
        final mimeType = _getMimeType(path);

        await db.into(db.mediaTable).insert(
              MediaTableCompanion.insert(
                id: '${momentId}_${DateTime.now().millisecondsSinceEpoch}',
                momentId: momentId,
                data: bytes,
                mimeType: mimeType,
                createdAt: DateTime.now(),
              ),
            );
      }
      return unit;
    }, description: 'saveMedia');
  }

  @override
  Future<Either<LocalFailure, Unit>> updateMoment(MomentDto moment) async {
    return await _driftClient.runQuery<Unit>((db) async {
      await db.transaction(() async {
        await db.into(db.momentTable).insertOnConflictUpdate(
              MomentTableCompanion.insert(
                id: moment.id,
                reflection: moment.reflection,
                date: DateTime.parse(moment.date),
                modifiedAt: DateTime.parse(moment.modifiedAt),
              ),
            );
      });
      return unit;
    }, description: 'updateMoment');
  }

  @override
  Future<Either<LocalFailure, Unit>> updateMedia(
    String momentId,
    List<String> mediaPaths,
  ) async {
    return await _driftClient.runQuery<Unit>((db) async {
      // 1. Delete existing media files
      await (db.delete(db.mediaTable)
            ..where((tbl) => tbl.momentId.equals(momentId)))
          .go();

      // 2. Insert new media files
      for (final path in mediaPaths) {
        final file = File(path);
        if (!await file.exists()) {
          throw LocalFailure(
            message: '파일을 찾을 수 없습니다.',
            code: 'FILE_NOT_FOUND',
            details: {'path': path},
          );
        }

        final bytes = await file.readAsBytes();
        final mimeType = _getMimeType(path);

        await db.into(db.mediaTable).insert(
              MediaTableCompanion.insert(
                id: '${momentId}_${DateTime.now().millisecondsSinceEpoch}',
                momentId: momentId,
                data: bytes,
                mimeType: mimeType,
                createdAt: DateTime.now(),
              ),
            );
      }
      return unit;
    }, description: 'updateMedia');
  }

  @override
  Future<Either<LocalFailure, Unit>> deleteMedias(
    String momentId,
    List<String> mediaIds,
  ) async {
    return await _driftClient.runQuery<Unit>((db) async {
      await (db.delete(db.mediaTable)
            ..where(
                (tbl) => tbl.momentId.equals(momentId) & tbl.id.isIn(mediaIds)))
          .go();
      return unit;
    }, description: 'deleteMedias');
  }

  @override
  Future<Either<LocalFailure, List<MediaInfoDto>>> fetchMediaByMomentId(
    String momentId,
  ) async {
    return await _driftClient.runQuery<List<MediaInfoDto>>((db) async {
      final mediaList = await (db.select(db.mediaTable)
            ..where((tbl) => tbl.momentId.equals(momentId))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
          .get();
      return mediaList.map((e) => MediaInfoDto.fromTableData(e)).toList();
    }, description: 'fetchMediaByMomentId');
  }

  String _getMimeType(String path) {
    return MimeType.getMimeTypeFromPath(path);
  }
}
