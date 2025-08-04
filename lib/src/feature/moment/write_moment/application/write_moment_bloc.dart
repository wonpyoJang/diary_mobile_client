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
    if (change.currentState != change.nextState) {
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

    on<TextChangedEvent>((event, emit) {
      final needToSave = state.mode == WriteMode.create &&
          event.newText.isNotEmpty &&
          state.isSaved == false;

      if (needToSave) {
        bus.publish(MomentCreatedMessage(moment: state.moment, date: date));
      }

      final newMoment = state.moment.copyWith(reflection: event.newText);

      emit(state.copyWith(moment: newMoment, isSaved: needToSave));
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<AddMedias>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final response = await writeMomentRepository.selectMedias();

      response.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          failure: failure,
        )),
        (medias) {
          final needToSave = state.mode == WriteMode.create &&
              medias.isNotEmpty &&
              state.isSaved == false;

          if (state.mode == WriteMode.create &&
              medias.isNotEmpty &&
              state.isSaved == false) {
            bus.publish(MomentCreatedMessage(moment: state.moment, date: date));
          }

          final newMoment = state.moment.copyWith(
            medias: [
              ...state.moment.medias,
              ...medias,
            ],
          );

          emit(state.copyWith(
            isLoading: false,
            medias: [
              ...state.medias,
              ...medias,
            ],
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
        medias: newMomentMedias,
        moment: newMoment,
      ));
    }, transformer: debounce(const Duration(milliseconds: 500)));

    on<ChangeToEdit>((event, emit) {
      emit(state.copyWith(mode: WriteMode.edit));
    });
  }
}
