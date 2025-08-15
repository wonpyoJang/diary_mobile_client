import 'dart:async';
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

  // 이벤트 트랜스포머 유틸리티 메서드들
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).asyncExpand(mapper);
  }

  EventTransformer<T> throttle<T>(Duration duration) {
    return (events, mapper) =>
        events.throttleTime(duration).asyncExpand(mapper);
  }

  WriteMomentBloc(
    this.bus,
    @factoryParam this.moment,
    @factoryParam this.date,
    this.writeMomentRepository,
  ) : super(moment == null
            ? WriteMomentState(
                mode: WriteMode.create,
                moment: Moment(
                  id: const Uuid().v1(),
                  reflection: "",
                  date: date,
                  modifiedAt: DateTime.now(),
                  emotionalIntensities: const [],
                  medias: const [],
                ),
              )
            : WriteMomentState(
                mode: WriteMode.view,
                moment: moment,
              )) {
    _registerEventHandlers();
    add(const FetchMedias());
  }

  // 이벤트 핸들러 등록
  void _registerEventHandlers() {
    on<FetchMedias>(_onFetchMedias);
    on<Analyzed>(_onAnalyzed,
        transformer: throttle(const Duration(milliseconds: 500)));
    on<TextChangedEvent>(_onTextChanged,
        transformer: debounce(const Duration(milliseconds: 500)));
    on<AddMedias>(_onAddMedias,
        transformer: debounce(const Duration(milliseconds: 500)));
    on<DeleteMedia>(_onDeleteMedia,
        transformer: debounce(const Duration(milliseconds: 500)));
    on<ChangeToEdit>(_onChangeToEdit);
    on<WriteByImage>(_onWriteByImage);
    on<ResetIsTextGenerated>(_onResetIsTextGenerated);
  }

  @override
  void onChange(Change<WriteMomentState> change) {
    if (change.currentState.moment != change.nextState.moment) {
      bus.publish(MomentModifiedMessage(
        moment: change.nextState.moment,
        modeifiedAt: change.nextState.moment.modifiedAt,
      ));
    }
    super.onChange(change);
  }

  // 이벤트 핸들러 메서드들
  Future<void> _onAnalyzed(
      Analyzed event, Emitter<WriteMomentState> emit) async {
    emit(state.copyWith(isLoading: true, hasAnalyzed: false));

    final response = await writeMomentRepository.analyze(state.moment);

    emit(response.fold(
      (failure) => state.copyWith(isLoading: false, failure: failure),
      (moment) => state.copyWith(
        isLoading: false,
        moment: moment,
        hasAnalyzed: true,
        mode: WriteMode.view,
      ),
    ));
  }

  Future<void> _onTextChanged(
      TextChangedEvent event, Emitter<WriteMomentState> emit) async {
    final newMoment = state.moment.copyWith(reflection: event.newText);
    final needToSave = _shouldSaveMoment(event.newText);

    if (needToSave) {
      await _saveNewMoment(newMoment, emit);
    } else {
      await _updateExistingMoment(newMoment, emit);
    }
  }

  Future<void> _onAddMedias(
      AddMedias event, Emitter<WriteMomentState> emit) async {
    emit(state.copyWith(isLoading: true));

    final response = await writeMomentRepository.selectMedias();

    emit(await response.fold(
      (failure) => state.copyWith(isLoading: false, failure: failure),
      (medias) async => await _handleMediaAddition(medias),
    ));
  }

  Future<void> _onDeleteMedia(
      DeleteMedia event, Emitter<WriteMomentState> emit) async {
    emit(state.copyWith(isLoading: true));

    final newMomentMedias = List<File>.from(state.moment.medias);
    if (event.index >= 0 && event.index < newMomentMedias.length) {
      newMomentMedias.removeAt(event.index);
    }

    final newMoment = state.moment.copyWith(medias: newMomentMedias);

    emit(state.copyWith(
      isLoading: false,
      moment: newMoment,
    ));
  }

  void _onChangeToEdit(ChangeToEdit event, Emitter<WriteMomentState> emit) {
    emit(state.copyWith(mode: WriteMode.edit));
  }

  Future<void> _onWriteByImage(
      WriteByImage event, Emitter<WriteMomentState> emit) async {
    emit(state.copyWith(isLoading: true));

    final response = await writeMomentRepository.describeImage(state.moment);

    emit(response.fold(
      (failure) => state.copyWith(failure: failure),
      (reflection) => state.copyWith(
        isLoading: false,
        moment: state.moment.copyWith(reflection: reflection),
        isTextGenerated: true,
      ),
    ));
  }

  void _onResetIsTextGenerated(
      ResetIsTextGenerated event, Emitter<WriteMomentState> emit) {
    emit(state.copyWith(isTextGenerated: false));
  }

  // 헬퍼 메서드들
  bool _shouldSaveMoment(String newText) {
    return state.mode == WriteMode.create &&
        newText.isNotEmpty &&
        !state.isSaved;
  }

  Future<void> _saveNewMoment(
      Moment newMoment, Emitter<WriteMomentState> emit) async {
    final result = await writeMomentRepository.saveMoment(newMoment);

    emit(result.fold(
      (failure) => state.copyWith(failure: failure),
      (unit) {
        bus.publish(MomentCreatedMessage(moment: state.moment, date: date));
        return state.copyWith(isSaved: true, moment: newMoment);
      },
    ));
  }

  Future<void> _updateExistingMoment(
      Moment newMoment, Emitter<WriteMomentState> emit) async {
    final result = await writeMomentRepository.updateMoment(newMoment);

    emit(result.fold(
      (failure) => state.copyWith(failure: failure),
      (unit) => state.copyWith(moment: newMoment, isSaved: false),
    ));
  }

  Future<WriteMomentState> _handleMediaAddition(List<File> medias) async {
    final result =
        await writeMomentRepository.saveMedias(state.moment.id, medias);

    return result.fold(
      (failure) => state.copyWith(failure: failure),
      (unit) async {
        final newMoment = state.moment.copyWith(
          medias: [...state.moment.medias, ...medias],
        );

        final needToSave = _shouldSaveMomentWithMedia(medias);

        if (needToSave) {
          return await _saveMomentWithMedia(newMoment);
        } else {
          return await _updateMomentWithMedia(medias, newMoment);
        }
      },
    );
  }

  bool _shouldSaveMomentWithMedia(List<File> medias) {
    return state.mode == WriteMode.create &&
        medias.isNotEmpty &&
        !state.isSaved;
  }

  Future<WriteMomentState> _saveMomentWithMedia(Moment newMoment) async {
    bus.publish(MomentCreatedMessage(moment: newMoment, date: date));

    final saveResult = await writeMomentRepository.saveMoment(newMoment);

    return saveResult.fold(
      (failure) => state.copyWith(isLoading: false, failure: failure),
      (unit) => state.copyWith(
        isLoading: false,
        isSaved: true,
        moment: newMoment,
      ),
    );
  }

  Future<WriteMomentState> _updateMomentWithMedia(
      List<File> medias, Moment newMoment) async {
    final result =
        await writeMomentRepository.updateMedias(newMoment.id, medias);

    return result.fold(
      (failure) => state.copyWith(failure: failure, isLoading: false),
      (unit) => state.copyWith(
        isSaved: true,
        moment: newMoment,
        isLoading: false,
      ),
    );
  }

  FutureOr<void> _onFetchMedias(
      FetchMedias event, Emitter<WriteMomentState> emit) async {
    final result =
        await writeMomentRepository.fetchMediasByMomentId(state.moment.id);

    emit(result.fold(
      (failure) => state.copyWith(failure: failure),
      (medias) => state.copyWith(
        moment: state.moment.copyWith(
            medias: medias
                .where((e) => e.file != null)
                .map((e) => e.file!)
                .toList()),
      ),
    ));
  }
}
