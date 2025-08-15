import 'dart:io';

import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class IWriteMomentRepository {
  Future<Either<WriteMomentFailure, List<File>>> selectMedias();

  Future<Either<WriteMomentFailure, Moment>> analyze(Moment text);

  Future<Either<WriteMomentFailure, String>> describeImage(Moment moment);

  Future<Either<WriteMomentFailure, Unit>> saveMoment(Moment moment);

  Future<Either<WriteMomentFailure, Unit>> saveMedias(
      String momentId, List<File> medias);

  Future<Either<WriteMomentFailure, Unit>> updateMoment(Moment moment);

  Future<Either<WriteMomentFailure, Unit>> updateMedias(
      String momentId, List<File> medias);

  Future<Either<WriteMomentFailure, Unit>> deleteMedias(
      String momentId, List<String> mediaIds);

  Future<Either<WriteMomentFailure, List<MediaInfo>>> fetchMediasByMomentId(
    String momentId,
  );
}
