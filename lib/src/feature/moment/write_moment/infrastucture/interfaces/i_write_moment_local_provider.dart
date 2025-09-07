import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/dtos/media_info_dto.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IWriteMomentLocalProvider {
  /// [DEPRECATED] 트랜잭션 분리로 인해 더 이상 사용하지 않음
  Future<Either<LocalFailure, Unit>> saveMoment(MomentDto moment);

  /// moment만 저장
  Future<Either<LocalFailure, Unit>> saveMomentOnly(MomentDto moment);

  /// intensity만 저장
  Future<Either<LocalFailure, Unit>> saveEmotionalIntensities(
      String momentId, List<EmotionalIntensityDto> intensities);
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
