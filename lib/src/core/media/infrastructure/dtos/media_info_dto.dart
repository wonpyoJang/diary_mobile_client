// import 'dart:io';
import 'dart:io' show File;
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';

class MediaInfoDto {
  final String id;
  final String momentId;
  final String path;
  final String mimeType;
  final DateTime createdAt;

  MediaInfoDto({
    required this.id,
    required this.momentId,
    required this.path,
    required this.mimeType,
    required this.createdAt,
  });

  MediaInfo toDomain() {
    return MediaInfo(
      id: id,
      momentId: momentId,
      file: _resolveFile(),
      mimeType: _parseMimeType(mimeType),
      createdAt: createdAt,
    );
  }

  factory MediaInfoDto.fromDomain(MediaInfo mediaInfo) {
    return MediaInfoDto(
      id: mediaInfo.id,
      momentId: mediaInfo.momentId,
      path: mediaInfo.file?.path ?? '',
      mimeType: mediaInfo.mimeType.name,
      createdAt: mediaInfo.createdAt,
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

  MediaTableData toTableData() {
    return MediaTableData(
      id: id,
      momentId: momentId,
      path: path,
      mimeType: mimeType,
      createdAt: createdAt,
    );
  }

  factory MediaInfoDto.fromTableData(MediaTableData tableData) {
    return MediaInfoDto(
      id: tableData.id,
      momentId: tableData.momentId,
      path: tableData.path,
      mimeType: tableData.mimeType,
      createdAt: tableData.createdAt,
    );
  }
}
