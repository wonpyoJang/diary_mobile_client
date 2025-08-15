import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/dtos/media_info_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IWriteMomentLocalProvider {
  Future<Either<LocalFailure, Unit>> saveMoment(MomentDto moment);
  Future<Either<LocalFailure, Unit>> saveMedia(
      String momentId, List<String> mediaPaths);
  Future<Either<LocalFailure, Unit>> updateMoment(MomentDto moment);
  Future<Either<LocalFailure, Unit>> updateMedia(
      String momentId, List<String> mediaPaths);
  Future<Either<LocalFailure, Unit>> deleteMedias(
      String momentId, List<String> mediaIds);
  Future<Either<LocalFailure, List<MediaInfoDto>>> fetchMediaByMomentId(
    String momentId,
  );
}
