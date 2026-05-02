import 'dart:io';

import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/generated_image/infrastructure/dtos/generated_image_dtos.dart';
import 'package:diary_mobile_client/src/feature/generated_image/infrastructure/providers/interfaces/i_generated_image_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: IGeneratedImageLocalProvider)
class GeneratedImageLocalProvider implements IGeneratedImageLocalProvider {
  final DriftClient _driftClient;

  GeneratedImageLocalProvider(this._driftClient);

  @override
  Future<Either<LocalFailure, Unit>> saveGeneratedImage(
      String momentId, String path) async {
    final file = File(path);
    if (!await file.exists()) {
      return left(LocalFailure(
        message: '파일을 찾을 수 없습니다.',
        code: 'FILE_NOT_FOUND',
        details: {'path': path},
      ));
    }

    return await _driftClient.runQuery<Unit>((db) async {
      final mimeType = _getMimeType(path);

      await db.into(db.generatedImageTable).insert(
          GeneratedImageTableCompanion.insert(
              id: '${momentId}_${DateTime.now().millisecondsSinceEpoch}',
              momentId: momentId,
              path: path,
              mimeType: mimeType,
              createdAt: DateTime.now()));
      return unit;
    }, description: 'saveGeneratedImage');
  }

  String _getMimeType(String path) {
    return MimeType.getMimeTypeFromPath(path);
  }

  @override
  Future<Either<LocalFailure, GeneratedImageDto>> fetchGeneratedImages(
      String momentId) async {
    return await _driftClient.runQuery<GeneratedImageDto>((db) async {
      final generatedImage = await (db.select(db.generatedImageTable)
            ..where((tbl) => tbl.momentId.equals(momentId)))
          .getSingle();

      // 현재 컨테이너의 Documents 경로 기준으로 리매핑 (테스트 환경 안전)
      String? currentDocsPath;
      try {
        final documentsDir = await getApplicationDocumentsDirectory();
        currentDocsPath = documentsDir.path;
      } catch (_) {
        // 테스트 환경(vm) 등 바인딩 미초기화 시 리매핑을 생략
        currentDocsPath = null;
      }

      final dto = GeneratedImageDto.fromTableData(generatedImage);
      final remappedPath = currentDocsPath == null
          ? dto.path
          : _remapToCurrentDocumentsPath(
              storedPath: dto.path,
              currentDocumentsPath: currentDocsPath,
            );
      return GeneratedImageDto(
        id: dto.id,
        momentId: dto.momentId,
        path: remappedPath,
        mimeType: dto.mimeType,
        createdAt: dto.createdAt,
      );
    }, description: 'fetchGeneratedImages');
  }

  String _remapToCurrentDocumentsPath({
    required String storedPath,
    required String currentDocumentsPath,
  }) {
    try {
      if (storedPath.isEmpty) return storedPath;
      const documentsSegment = '/Documents/';
      final idx = storedPath.indexOf(documentsSegment);
      if (idx == -1) {
        return storedPath;
      }
      final relative = storedPath.substring(idx + documentsSegment.length);
      return '$currentDocumentsPath/$relative';
    } catch (_) {
      return storedPath;
    }
  }
}
