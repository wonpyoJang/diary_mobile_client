import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/domain/repositories/i_mieda_info_repository.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/providers/interfaces/i_media_info_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IMediaInfoRepository)
class MediaInfoRepository implements IMediaInfoRepository {
  final IMediaInfoLocalProvider provider;

  MediaInfoRepository(this.provider);

  @override
  Future<Either<LocalFailure, List<File>>> selectMedias() async {
    return await provider.selectMedias().then(
          (result) => result.fold(
            (failure) => left(failure),
            (medias) => right(medias.map((e) => File(e.path)).toList()),
          ),
        );
  }

  @override
  Future<Either<LocalFailure, List<File>>> saveMedias(List<File> medias) async {
    return await provider
        .saveMedias(medias.map((e) => XFile(e.path)).toList())
        .then(
          (result) => result.fold(
            (failure) => left(failure),
            (medias) => right(medias),
          ),
        );
  }
}
