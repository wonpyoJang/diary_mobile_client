import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@singleton
class ICloudService {
  static const _channel = MethodChannel('com.crepas.diary/icloud');

  /// iCloud에 파일 업로드
  Future<bool> uploadToICloud(String fileName, String content) async {
    final result = await _channel.invokeMethod('uploadToICloud', {
      'fileName': fileName,
      'content': content,
    });
    return result == true;
  }

  /// iCloud에 파일 저장
  Future<bool> saveToICloud(String filePath) async {
    final result =
        await _channel.invokeMethod('saveToICloud', {'path': filePath});
    return result == "true";
  }

  /// iCloud에서 파일 다운로드
  Future<String?> downloadFromICloud(String fileName) async {
    final result = await _channel
        .invokeMethod('downloadFromICloud', {'fileName': fileName});
    return result;
  }

  /// iCloud 파일 목록 조회
  Future<List<String>> listICloudFiles() async {
    final result = await _channel.invokeMethod('listICloudFiles');
    return (result as List).cast<String>();
  }

  /// 파일(app sandbox 내 경로)을 '파일' 앱을 통해 사용자 iCloud(또는 로컬)에 내보내기
  Future<bool> exportToFiles(String filePath) async {
    final result = await _channel.invokeMethod('exportToFiles', {
      'path': filePath,
    });
    return result == true;
  }
}
