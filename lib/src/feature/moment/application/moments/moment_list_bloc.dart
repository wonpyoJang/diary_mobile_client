import 'dart:async';
import 'dart:collection';

import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/domain/interface/i_moment_list_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../bus/bus.dart';
import '../../../../bus/bus_message.dart';
import 'moment_list_event.dart';
import 'moment_list_state.dart';

@injectable
class MomentListBloc extends Bloc<MomentListEvent, MomentListState> {
  final Bus bus;
  final IMomentListRepository momentListRepository;
  late StreamSubscription<BusMessage> busSubscription;

  @override
  Future<void> close() {
    busSubscription.cancel();
    return super.close();
  }

  MomentListBloc(this.bus, this.momentListRepository)
      : super(MomentListState(
            moments: LinkedHashMap(
          equals: isSameDay,
          hashCode: getHashCode,
        ))) {
    busSubscription = bus.subscribe((message) {
      if (message is MomentCreatedMessage) {
        add(AddMoment(message.moment, message.date));
      } else if (message is MomentDeletedMessage) {
        add(DeleteMoment(message.moment));
      } else if (message is MomentModifiedMessage) {
        add(UpdateMoment(message.moment, message.modeifiedAt));
      }
    });

    on<LoadMoments>((event, emit) async {
      // repository를 통해 모든 일기를 가져옵니다
      final result = await momentListRepository.getAllMoments();

      emit(result.fold(
        (failure) {
          // 실패 시 빈 상태로 초기화
          return MomentListState(
            moments: LinkedHashMap(
              equals: isSameDay,
              hashCode: getHashCode,
            ),
          );
        },
        (moments) {
          // 첫 번째 날짜를 찾습니다
          final firstDay = _calculateFirstDay(moments);

          // 상태를 업데이트합니다
          return MomentListState(moments: moments, firstDay: firstDay);
        },
      ));
    });

    on<AddMoment>((event, emit) {
      final newMoments = LinkedHashMap<DateTime, List<Moment>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(state.moments);

      final existing = newMoments[event.moment.date] ?? const <Moment>[];
      newMoments[event.moment.date] = [event.moment, ...existing];

      // 새로운 moment의 date가 기존 firstDay보다 이른 경우에만 업데이트
      DateTime? firstDay = state.firstDay;
      if (firstDay == null || event.moment.date.isBefore(firstDay)) {
        firstDay = event.moment.date;
      }

      emit(state.copyWith(moments: newMoments, firstDay: firstDay));
    });

    on<UpdateMoment>(
      (event, emit) {
        final updatedMoments = state.moments;

        updatedMoments[event.moment.date] = updatedMoments[event.moment.date]!
            .map((moment) =>
                moment.id == event.moment.id ? event.moment : moment)
            .toList();

        // moment가 업데이트된 경우, 새로운 date가 firstDay보다 이른지 확인
        DateTime? firstDay = state.firstDay;
        if (firstDay == null || event.moment.date.isBefore(firstDay)) {
          firstDay = event.moment.date;
        }

        emit(MomentListState(moments: updatedMoments, firstDay: firstDay));
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );

    on<DeleteMoment>((event, emit) async {
      final result = await momentListRepository.deleteMoment(event.moment.id);

      emit(result.fold((l) => state.copyWith(failure: l), (r) {
        final updatedMoments = state.moments;
        updatedMoments[event.moment.date] = updatedMoments[event.moment.date]!
            .where((moment) => moment.id != event.moment.id)
            .toList();
        // moment가 삭제된 경우, 삭제된 moment가 firstDay였다면 재계산 필요
        DateTime? firstDay = state.firstDay;
        if (firstDay != null && isSameDay(event.moment.date, firstDay)) {
          firstDay = _calculateFirstDay(updatedMoments);
        }
        return MomentListState(moments: updatedMoments, firstDay: firstDay);
      }));
    });
  }

  /// 캘린더의 가장 첫번째 날을 계산하는 헬퍼 메서드
  DateTime? _calculateFirstDay(LinkedHashMap<DateTime, List<Moment>> moments) {
    if (moments.isEmpty) return null;

    DateTime? firstDay;

    // 모든 moment의 date 중 가장 이른 날짜를 찾습니다
    for (final entry in moments.entries) {
      final momentList = entry.value;

      for (final moment in momentList) {
        if (firstDay == null || moment.date.isBefore(firstDay)) {
          firstDay = moment.date;
        }
      }
    }

    return firstDay;
  }

  // @override
  // MomentListState? fromJson(Map<String, dynamic> json) {
  //   if (json['moments'] == null) return null;

  //   final momentsJson = json['moments'] as List<dynamic>;
  //   final moments = LinkedHashMap<DateTime, List<Moment>>(
  //     equals: isSameDay,
  //     hashCode: getHashCode,
  //   );

  //   for (final entry in momentsJson) {
  //     final date = DateTime.parse(entry['date'] as String);
  //     final momentsList = (entry['moments'] as List<dynamic>).map((momentJson) {
  //       return Moment(
  //         id: momentJson['id'] as String,
  //         reflection: momentJson['reflection'] as String,
  //         date: DateTime.parse(momentJson['date'] as String),
  //         modifiedAt: DateTime.parse(momentJson['modifiedAt'] as String),
  //         emotionalIntensities:
  //             (momentJson['emotionalIntensities'] as List<dynamic>)
  //                 .map((e) => EmotionalIntensity(
  //                       emotion: Emotion.findByName(e['emotion'] as String),
  //                       intensity: e['intensity'] as double,
  //                     ))
  //                 .toList(),
  //         medias: (momentJson['medias'] as List<dynamic>)
  //             .map((e) => File(e['path'] as String))
  //             .toList(),
  //       );
  //     }).toList();

  //     moments[date] = momentsList;
  //   }

  //   final firstDay = json['firstDay'] != null
  //       ? DateTime.parse(json['firstDay'] as String)
  //       : null;

  //   return MomentListState(moments: moments, firstDay: firstDay);
  // }

  // @override
  // Map<String, dynamic>? toJson(MomentListState state) {
  //   return {
  //     'moments': state.moments.entries.map((entry) {
  //       final date = entry.key;
  //       final moments = entry.value;
  //       return {
  //         'date': date.toIso8601String(),
  //         'moments': moments
  //             .map((moment) => {
  //                   'id': moment.id,
  //                   'reflection': moment.reflection,
  //                   'date': moment.date.toIso8601String(),
  //                   'modifiedAt': moment.modifiedAt.toIso8601String(),
  //                   'emotionalIntensities': moment.emotionalIntensities
  //                       .map((e) => {
  //                             'emotion': e.emotion.name,
  //                             'intensity': e.intensity,
  //                           })
  //                       .toList(),
  //                   'medias': moment.medias
  //                       .map((media) => {
  //                             'path': media.path,
  //                           })
  //                       .toList(),
  //                 })
  //             .toList(),
  //       };
  //     }).toList(),
  //     'firstDay': state.firstDay?.toIso8601String(),
  //   };
  // }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
