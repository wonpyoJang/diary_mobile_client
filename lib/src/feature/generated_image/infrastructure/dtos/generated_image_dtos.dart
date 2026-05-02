import 'dart:io';

import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/generated_image/domain/entity/generated_image.dart';

class GeneratedImageDto {
  final String id;
  final String momentId;
  final String path;
  final String mimeType;
  final DateTime createdAt;

  GeneratedImageDto({
    required this.id,
    required this.momentId,
    required this.path,
    required this.mimeType,
    required this.createdAt,
  });

  GeneratedImage toDomain() {
    return GeneratedImage(
      id: id,
      momentId: momentId,
      path: path,
      mimeType: _parseMimeType(mimeType),
      createdAt: createdAt,
      file: _resolveFile()!,
    );
  }

  factory GeneratedImageDto.fromDomain(GeneratedImage domain) {
    return GeneratedImageDto(
      id: domain.id,
      momentId: domain.momentId,
      path: domain.path,
      mimeType: domain.mimeType.name,
      createdAt: domain.createdAt,
    );
  }

  File? _resolveFile() {
    try {
      if (path.isEmpty) return null;
      final file = File(path);
      if (!file.existsSync()) return null;
      return file;
    } catch (e) {
      return null;
    }
  }

  // 경로 기반 저장으로 전환하여 파일 생성 로직은 더 이상 필요하지 않음
  // (참고용으로 남겨둔 플랫폼 헬퍼)

  MimeType _parseMimeType(String mimeTypeString) {
    return MimeType.fromMimeTypeString(mimeTypeString);
  }

  GeneratedImageTableData toTableData() {
    return GeneratedImageTableData(
      id: id,
      momentId: momentId,
      path: path,
      mimeType: mimeType,
      createdAt: createdAt,
    );
  }

  factory GeneratedImageDto.fromTableData(GeneratedImageTableData tableData) {
    return GeneratedImageDto(
      id: tableData.id,
      momentId: tableData.momentId,
      path: tableData.path,
      mimeType: tableData.mimeType,
      createdAt: tableData.createdAt,
    );
  }
}
