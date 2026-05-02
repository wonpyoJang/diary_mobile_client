import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IMediaInfoRepository {
  Future<Either<LocalFailure, List<File>>> selectMedias();
  Future<Either<LocalFailure, List<File>>> saveMedias(List<File> medias);
}
