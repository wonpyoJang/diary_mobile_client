import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/providers/interfaces/i_media_info_local_provider.dart';
import 'package:diary_mobile_client/src/feature/generated_image/domain/entity/generated_image.dart';
import 'package:diary_mobile_client/src/feature/generated_image/domain/repositories/interfaces/i_generated_image_repository.dart';
import 'package:diary_mobile_client/src/feature/generated_image/infrastructure/providers/interfaces/i_generated_image_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IGeneratedImageRepository)
class GenerateImageRepository implements IGeneratedImageRepository {
  final IGeneratedImageLocalProvider provider;
  final IMediaInfoLocalProvider mediaInfoLocalProvider;

  GenerateImageRepository(this.provider, this.mediaInfoLocalProvider);

  @override
  Future<Either<LocalFailure, Unit>> saveGeneratedImage(
      String momentId, String path) async {
    return await provider.saveGeneratedImage(momentId, path);
  }

  @override
  Future<Either<LocalFailure, GeneratedImage>> fetchGeneratedImages(
      String momentId) async {
    return await provider.fetchGeneratedImages(momentId).then(
          (result) => result.fold(
            (failure) => left(failure),
            (generatedImage) => right(generatedImage.toDomain()),
          ),
        );
  }
}
