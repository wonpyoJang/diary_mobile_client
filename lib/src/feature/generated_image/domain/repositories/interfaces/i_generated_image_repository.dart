import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/generated_image/domain/entity/generated_image.dart';
import 'package:fpdart/fpdart.dart';

abstract class IGeneratedImageRepository {
  Future<Either<LocalFailure, Unit>> saveGeneratedImage(
      String momentId, String path);

  Future<Either<LocalFailure, GeneratedImage>> fetchGeneratedImages(
      String momentId);
}
