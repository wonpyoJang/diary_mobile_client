import 'dart:io';

import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/interface/i_write_moment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../bus/bus.dart';
import '../../domain/entity/moment.dart';
import 'write_moment_event.dart';
import 'write_moment_state.dart';

enum WriteMode { create, edit, view }

@injectable
class WriteMomentBloc extends Bloc<WriteMomentEvent, WriteMomentState> {
  final Bus bus;
  final Moment? moment;
  final DateTime date;
  final IWriteMomentRepository writeMomentRepository;
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).asyncExpand(mapper);
  }

  EventTransformer<T> throttle<T>(Duration duration) {
    return (events, mapper) =>
        events.throttleTime(duration).asyncExpand(mapper);
  }

  @override
  void onChange(Change<WriteMomentState> change) {
    if (change.currentState.moment != change.nextState.moment) {
      bus.publish(MomentModifiedMessage(
          moment: change.nextState.moment,
          modeifiedAt: change.nextState.moment.modifiedAt));
    }
    super.onChange(change);
  }

  WriteMomentBloc(
    this.bus,
    @factoryParam this.moment,
    @factoryParam this.date,
    this.writeMomentRepository,
  ) : super(WriteMomentState(
            mode: moment != null ? WriteMode.view : WriteMode.create,
            moment: moment ??
                Moment(
                  id: const Uuid().v1(),
                  reflection: "",
                  date: date,
                  modifiedAt: DateTime.now(),
                  emotionalIntensities: const [],
                  medias: const [],
                ))) {
    on<Analyzed>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final response = await writeMomentRepository.analyze(state.moment);

      emit(response.fold(
        (failure) => state.copyWith(isLoading: false, failure: failure),
        (moment) => state.copyWith(
            isLoading: false, moment: moment, mode: WriteMode.view),
      ));
    }, transformer: throttle(const Duration(milliseconds: 500)));

    on<TextChangedEvent>((event, emit) async {
      final needToSave = state.mode == WriteMode.create &&
          event.newText.isNotEmpty &&
          state.isSaved == false;

      // 모먼트를 로컬 저장소에 저장

      final newMoment = state.moment.copyWith(reflection: event.newText);

      if (needToSave) {
        final result = await writeMomentRepository.saveMoment(newMoment);
        emit(result.fold(
          (failure) => state.copyWith(failure: failure),
          (unit) {
            bus.publish(MomentCreatedMessage(moment: state.moment, date: date));

            return state.copyWith(isSaved: true, moment: newMoment);
          },
        ));
      } else {
        final result = await writeMomentRepository.updateMoment(newMoment);

        emit(result.fold((failure) => state.copyWith(failure: failure),
            (unit) => state.copyWith(moment: newMoment, isSaved: needToSave)));
      }
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<AddMedias>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final response = await writeMomentRepository.selectMedias();

      response.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          failure: failure,
        )),
        (medias) async {
          final needToSave = state.mode == WriteMode.create &&
              medias.isNotEmpty &&
              state.isSaved == false;

          if (needToSave) {
            bus.publish(MomentCreatedMessage(moment: state.moment, date: date));
            final saveResult =
                await writeMomentRepository.saveMoment(state.moment);
            saveResult.fold(
              (failure) =>
                  emit(state.copyWith(isLoading: false, failure: failure)),
              (unit) => null,
            );
          } else {
            final result = await writeMomentRepository.updateMedias(
                state.moment.id, medias);
            emit(result.fold((failure) => state.copyWith(failure: failure),
                (unit) => state.copyWith(isSaved: true)));
          }

          final result =
              await writeMomentRepository.saveMedias(state.moment.id, medias);
          emit(result.fold((failure) => state.copyWith(failure: failure),
              (unit) => state.copyWith(isSaved: true)));

          final newMoment = state.moment.copyWith(
            medias: [
              ...state.moment.medias,
              ...medias,
            ],
          );

          emit(state.copyWith(
            isLoading: false,
            moment: newMoment,
            isSaved: needToSave,
          ));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<DeleteMedia>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final newMomentMedias = List<File>.from(state.moment.medias);
      if (event.index >= 0 && event.index < newMomentMedias.length) {
        newMomentMedias.removeAt(event.index);
      }
      final newMoment = state.moment.copyWith(
        medias: newMomentMedias,
      );

      emit(state.copyWith(
        isLoading: false,
        moment: newMoment,
      ));
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<ChangeToEdit>((event, emit) {
      emit(state.copyWith(mode: WriteMode.edit));
    });

    on<WriteByImage>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final response = await writeMomentRepository.describeImage(state.moment);

      emit(response.fold((failure) => state.copyWith(failure: failure),
          (reflection) {
        return state.copyWith(
            isLoading: false,
            moment: state.moment.copyWith(reflection: reflection),
            isTextGenerated: true);
      }));
    });

    on<ResetIsTextGenerated>((event, emit) {
      emit(state.copyWith(isTextGenerated: false));
    });
  }
}
