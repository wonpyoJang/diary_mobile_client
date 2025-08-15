import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/dtos/media_info_dto.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_local_provider.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IWriteMomentLocalProvider)
class WriteMomentLocalProvider implements IWriteMomentLocalProvider {
  final Database _database;

  WriteMomentLocalProvider(this._database);

  @override
  Future<Either<LocalFailure, Unit>> saveMoment(MomentDto moment) async {
    try {
      await _database.transaction(() async {
        // 1. Save moment
        await _database.into(_database.momentTable).insert(
              MomentTableCompanion.insert(
                id: moment.id,
                reflection: moment.reflection,
                date: DateTime.parse(moment.date),
                modifiedAt: DateTime.parse(moment.modifiedAt),
              ),
            );

        // 2. Save emotional intensities
        for (final emotionalIntensity in moment.emotionalIntensities) {
          await _database.into(_database.emotionalIntensityTable).insert(
                EmotionalIntensityTableCompanion.insert(
                  id: '${moment.id}_${emotionalIntensity.emotion}',
                  emotion: Emotion.findByName(emotionalIntensity.emotion),
                  intensity: emotionalIntensity.intensity,
                  momentId: moment.id,
                ),
              );
        }
      });

      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '데이터베이스 저장 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> saveMedia(
    String momentId,
    List<String> mediaPaths,
  ) async {
    try {
      await _database.transaction(() async {
        for (final path in mediaPaths) {
          final file = File(path);
          if (!await file.exists()) {
            return left(LocalFailure(
              message: '파일을 찾을 수 없습니다.',
              code: 'FILE_NOT_FOUND',
              details: {'path': path},
            ));
          }

          final bytes = await file.readAsBytes();
          final mimeType = _getMimeType(path);

          await _database.into(_database.mediaTable).insert(
                MediaTableCompanion.insert(
                  id: '${momentId}_${DateTime.now().millisecondsSinceEpoch}',
                  momentId: momentId,
                  data: bytes,
                  mimeType: mimeType,
                  createdAt: DateTime.now(),
                ),
              );
        }
      });

      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '미디어 저장 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> updateMoment(MomentDto moment) async {
    try {
      await _database.transaction(() async {
        // 1. Update moment
        await (_database.update(_database.momentTable)
              ..where((tbl) => tbl.id.equals(moment.id)))
            .write(
          MomentTableCompanion(
            reflection: Value(moment.reflection),
            date: Value(DateTime.parse(moment.date)),
            modifiedAt: Value(DateTime.parse(moment.modifiedAt)),
          ),
        );

        // 2. Delete existing emotional intensities
        await (_database.delete(_database.emotionalIntensityTable)
              ..where((tbl) => tbl.momentId.equals(moment.id)))
            .go();

        // 3. Insert new emotional intensities
        for (final emotionalIntensity in moment.emotionalIntensities) {
          await _database.into(_database.emotionalIntensityTable).insert(
                EmotionalIntensityTableCompanion.insert(
                  id: '${moment.id}_${emotionalIntensity.emotion}',
                  emotion: Emotion.findByName(emotionalIntensity.emotion),
                  intensity: emotionalIntensity.intensity,
                  momentId: moment.id,
                ),
              );
        }
      });

      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '데이터베이스 업데이트 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> updateMedia(
    String momentId,
    List<String> mediaPaths,
  ) async {
    try {
      await _database.transaction(() async {
        // 1. Delete existing media files
        await (_database.delete(_database.mediaTable)
              ..where((tbl) => tbl.momentId.equals(momentId)))
            .go();

        // 2. Insert new media files
        for (final path in mediaPaths) {
          final file = File(path);
          if (!await file.exists()) {
            return left(LocalFailure(
              message: '파일을 찾을 수 없습니다.',
              code: 'FILE_NOT_FOUND',
              details: {'path': path},
            ));
          }

          final bytes = await file.readAsBytes();
          final mimeType = _getMimeType(path);

          await _database.into(_database.mediaTable).insert(
                MediaTableCompanion.insert(
                  id: '${momentId}_${DateTime.now().millisecondsSinceEpoch}',
                  momentId: momentId,
                  data: bytes,
                  mimeType: mimeType,
                  createdAt: DateTime.now(),
                ),
              );
        }
      });

      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '미디어 업데이트 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> deleteMedias(
    String momentId,
    List<String> mediaIds,
  ) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.mediaTable)
              ..where((tbl) =>
                  tbl.momentId.equals(momentId) & tbl.id.isIn(mediaIds)))
            .go();
      });

      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '미디어 삭제 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, List<MediaInfoDto>>> fetchMediaByMomentId(
    String momentId,
  ) async {
    try {
      final mediaList = await (_database.select(_database.mediaTable)
            ..where((tbl) => tbl.momentId.equals(momentId))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
          .get();

      return right(
          mediaList.map((e) => MediaInfoDto.fromTableData(e)).toList());
    } catch (e) {
      return left(LocalFailure(
        message: '미디어 조회 중 오류가 발생했습니다.',
        code: 'DB_ERROR',
        details: e.toString(),
      ));
    }
  }

  String _getMimeType(String path) {
    return MimeType.getMimeTypeFromPath(path);
  }
}
