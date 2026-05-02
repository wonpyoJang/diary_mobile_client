import 'dart:async';

import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/core/media/domain/repositories/i_mieda_info_repository.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/generated_image/application/generated_image_event.dart';
import 'package:diary_mobile_client/src/feature/generated_image/application/generated_image_state.dart';
import 'package:diary_mobile_client/src/feature/generated_image/domain/repositories/interfaces/i_generated_image_repository.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';

@injectable
class GeneratedImageBloc
    extends Bloc<GeneratedImageEvent, GeneratedImageState> {
  final IGeneratedImageRepository repository;
  final IMediaInfoRepository mediaInfoRepository;
  final Moment? moment;
  final Bus bus;
  late StreamSubscription<BusMessage> busSubscription;

  GeneratedImageBloc(
    this.repository,
    this.mediaInfoRepository,
    @factoryParam this.moment,
    this.bus,
  ) : super(GeneratedImageState.initial()) {
    busSubscription = bus.subscribe((message) {
      if (message is MomentCreatedMessage) {
        add(UpdateMoment(message.moment));
      }
    });

    on<UpdateMoment>((event, emit) {
      emit(state.copyWith(moment: event.moment));
    });

    on<FetchGeneratedImage>((event, emit) async {
      final nextState = await TaskEither<LocalFailure, GeneratedImageState>(
        () async {
          if (moment == null && state.moment == null) {
            return left(const LocalFailure(message: 'Moment is null'));
          }
          final res = await repository
              .fetchGeneratedImages(moment?.id ?? state.moment!.id);
          return res.map(
            (generatedImage) =>
                state.copyWith(generatedImage: generatedImage.file),
          );
        },
      ).run().then(
            (either) => either.fold(
              (failure) => state.copyWith(errorMessage: failure.message),
              (s) => s,
            ),
          );
      emit(nextState);
    });
    on<SaveGeneratedImage>((event, emit) async {
      if (moment == null && state.moment == null) {
        return;
      }
      final nextState = await TaskEither<LocalFailure, Unit>(() async {
        final res = await mediaInfoRepository.saveMedias([event.file]);
        return res.map((_) => unit);
      })
          .flatMap(
            (_) => TaskEither<LocalFailure, Unit>(
              () => repository.saveGeneratedImage(
                  moment?.id ?? state.moment!.id, event.file.path),
            ),
          )
          .map((_) => state.copyWith(generatedImage: event.file))
          .run()
          .then(
            (either) => either.fold(
              (failure) => state.copyWith(errorMessage: failure.message),
              (s) => s,
            ),
          );
      emit(nextState);
    });
  }
}
