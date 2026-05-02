import 'package:diary_mobile_client/src/feature/generated_image/infrastructure/dtos/generated_image_dtos.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IGeneratedImageLocalProvider {
  Future<Either<LocalFailure, Unit>> saveGeneratedImage(
      String momentId, String path);

  Future<Either<LocalFailure, GeneratedImageDto>> fetchGeneratedImages(
      String momentId);
}
