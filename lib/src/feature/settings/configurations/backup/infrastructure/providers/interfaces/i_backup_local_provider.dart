import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IBackupLocalProvider {
  Future<Either<LocalFailure, File>> exportDriftDatabase();

  /// 모든 일기 데이터를 CSV 문자열로 생성하여 임시 파일로 저장하고 파일 핸들을 반환합니다
  Future<Either<LocalFailure, File>> exportMomentsCsv();

  /// CSV와 사진 파일을 함께 담은 ZIP 파일을 생성하여 반환합니다
  Future<Either<LocalFailure, File>> exportMomentsCsvWithMediaZip();
}
