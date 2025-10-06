import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

abstract class IMediaInfoLocalProvider {
  Future<Either<LocalFailure, List<XFile>>> selectMedias();

  /// 미디어 파일을 저장하는 메소드
  /// [medias] : 저장할 XFile 리스트
  /// 반환값: 저장 성공 시 Unit, 실패 시 LocalFailure
  Future<Either<LocalFailure, List<File>>> saveMedias(List<XFile> tmpFiles);
}
