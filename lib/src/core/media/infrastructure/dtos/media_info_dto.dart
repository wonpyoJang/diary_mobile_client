import 'dart:io';
import 'dart:typed_data';
import 'dart:io' show Platform;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';

class MediaInfoDto {
  final String id;
  final String momentId;
  final Uint8List data;
  final String mimeType;
  final DateTime createdAt;

  MediaInfoDto({
    required this.id,
    required this.momentId,
    required this.data,
    required this.mimeType,
    required this.createdAt,
  });

  MediaInfo toDomain() {
    return MediaInfo(
      id: id,
      momentId: momentId,
      file: _createFileList(),
      mimeType: _parseMimeType(mimeType),
      createdAt: createdAt,
    );
  }

  factory MediaInfoDto.fromDomain(MediaInfo mediaInfo) {
    return MediaInfoDto(
      id: mediaInfo.id,
      momentId: mediaInfo.momentId,
      data: mediaInfo.file?.readAsBytesSync() ?? Uint8List(0),
      mimeType: mediaInfo.mimeType.name,
      createdAt: mediaInfo.createdAt,
    );
  }

  File? _createFileList() {
    try {
      // 앱의 문서 디렉토리에 media 폴더 생성
      final mediaDir = _getMediaDirectory();
      if (!mediaDir.existsSync()) {
        mediaDir.createSync(recursive: true);
      }

      // 파일 확장자 결정
      final extension = _getFileExtension(mimeType);
      final fileName =
          'media_${id}_${createdAt.millisecondsSinceEpoch}$extension';
      final filePath = path.join(mediaDir.path, fileName);

      // 파일 생성 및 데이터 쓰기
      final file = File(filePath);
      file.writeAsBytesSync(data);

      return file;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      print('Error creating file: $e');
      return null;
    }
  }

  Directory _getMediaDirectory() {
    if (Platform.isAndroid || Platform.isIOS) {
      // 모바일 플랫폼에서는 앱 문서 디렉토리 사용
      // 동기적으로 처리하기 위해 기본 경로 사용
      final appDocDir = _getAppDocumentsDirectorySync();
      return Directory('${appDocDir.path}/media');
    } else {
      // 데스크톱 플랫폼에서는 임시 디렉토리 사용
      return Directory.systemTemp;
    }
  }

  Directory _getAppDocumentsDirectorySync() {
    // 플랫폼별 기본 문서 디렉토리 경로
    if (Platform.isAndroid) {
      return Directory('/data/data/com.example.diary_mobile_client/documents');
    } else if (Platform.isIOS) {
      return Directory('${Directory.systemTemp.path}/Documents');
    } else {
      return Directory.systemTemp;
    }
  }

  String _getFileExtension(String mimeType) {
    return MimeType.getFileExtensionFromMimeType(mimeType);
  }

  MimeType _parseMimeType(String mimeTypeString) {
    return MimeType.fromMimeTypeString(mimeTypeString);
  }

  MediaTableData toTableData() {
    return MediaTableData(
      id: id,
      momentId: momentId,
      data: data,
      mimeType: mimeType,
      createdAt: createdAt,
    );
  }

  factory MediaInfoDto.fromTableData(MediaTableData tableData) {
    return MediaInfoDto(
      id: tableData.id,
      momentId: tableData.momentId,
      data: tableData.data,
      mimeType: tableData.mimeType,
      createdAt: tableData.createdAt,
    );
  }
}
