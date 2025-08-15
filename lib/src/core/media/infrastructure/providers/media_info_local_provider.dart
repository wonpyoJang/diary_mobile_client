import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/file/file_manager.dart';
import 'package:diary_mobile_client/src/core/image_picker/image_picker_client.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/interfaces/i_media_info_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IMeidaInfoLocalProvider)
class MediaInfoLocalProvider implements IMeidaInfoLocalProvider {
  final FileManager _fileManager = FileManager();
  final ImagePickerClient _imagePickerClient = ImagePickerClient();

  @override
  Future<Either<LocalFailure, List<XFile>>> selectMedias() async {
    // ImagePickerClient를 사용하여 미디어 선택
    return await _imagePickerClient.pickMultipleMedia();
  }

  @override
  Future<Either<LocalFailure, List<File>>> saveMedias(
      List<XFile> tmpFiles) async {
    // 파일 저장 로직이 필요하다면 _fileManager를 활용하여 구현
    // 현재는 단순히 성공 반환
    return _fileManager.saveMultipleImages(tmpFiles);
  }
}
