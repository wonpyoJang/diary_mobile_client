import 'dart:async';
import 'dart:collection';

import 'package:diary_mobile_client/src/feature/moment/application/moment_messages.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../bus/bus.dart';
import '../../../../bus/bus_message.dart';
import '../../domain/entity/moment.dart';
import 'moment_list_event.dart';
import 'moment_list_state.dart';

@injectable
class MomentListBloc extends HydratedBloc<MomentListEvent, MomentListState> {
  final Bus bus;
  late StreamSubscription<BusMessage> busSubscription;

  @override
  Future<void> close() {
    busSubscription.cancel();
    return super.close();
  }

  MomentListBloc(this.bus)
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

    on<LoadMoments>((event, meit) {});

    on<AddMoment>((event, emit) {
      final newMoments = state.moments;

      if (state.moments.containsKey(event.moment.date)) {
        newMoments[event.moment.date] = [
          event.moment,
          ...state.moments[event.moment.date]!
        ];
      } else {
        newMoments[event.moment.date] = [event.moment];
      }

      DateTime? firstDay;
      if (state.firstDay == null) {
        firstDay = event.moment.modifiedAt;
      }

      if (event.moment.modifiedAt.isBefore(firstDay!)) {
        firstDay = event.moment.modifiedAt;
      }

      emit(MomentListState(moments: newMoments, firstDay: firstDay));
    });

    on<UpdateMoment>(
      (event, emit) {
        final updatedMoments = state.moments;

        updatedMoments[event.moment.date] = updatedMoments[event.moment.date]!
            .map((moment) =>
                moment.id == event.moment.id ? event.moment : moment)
            .toList();

        emit(MomentListState(moments: updatedMoments));
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );

    on<DeleteMoment>((event, emit) {
      final updatedMoments = state.moments;

      updatedMoments[event.moment.date] = updatedMoments[event.moment.date]!
          .where((moment) => moment.id != event.moment.id)
          .toList();

      emit(MomentListState(moments: updatedMoments));
    });
  }

  @override
  MomentListState? fromJson(Map<String, dynamic> json) {
    if (json['moments'] == null) return null;

    final momentsJson = json['moments'] as List<dynamic>;
    final moments = LinkedHashMap<DateTime, List<Moment>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (final entry in momentsJson) {
      final date = DateTime.parse(entry['date'] as String);
      final momentsList = (entry['moments'] as List<dynamic>).map((momentJson) {
        return Moment(
          id: momentJson['id'] as String,
          reflection: momentJson['reflection'] as String,
          date: DateTime.parse(momentJson['date'] as String),
          modifiedAt: DateTime.parse(momentJson['modifiedAt'] as String),
          emotionalIntensities:
              (momentJson['emotionalIntensities'] as List<dynamic>)
                  .map((e) => EmotionalIntensity(
                        emotion: Emotion.findByName(e['emotion'] as String),
                        intensity: e['intensity'] as double,
                      ))
                  .toList(),
          medias: (momentJson['medias'] as List<dynamic>)
              .map((e) => XFile(e['path'] as String))
              .toList(),
        );
      }).toList();

      moments[date] = momentsList;
    }

    final firstDay = json['firstDay'] != null
        ? DateTime.parse(json['firstDay'] as String)
        : null;

    return MomentListState(moments: moments, firstDay: firstDay);
  }

  @override
  Map<String, dynamic>? toJson(MomentListState state) {
    return {
      'moments': state.moments.entries.map((entry) {
        final date = entry.key;
        final moments = entry.value;
        return {
          'date': date.toIso8601String(),
          'moments': moments
              .map((moment) => {
                    'id': moment.id,
                    'reflection': moment.reflection,
                    'date': moment.date.toIso8601String(),
                    'modifiedAt': moment.modifiedAt.toIso8601String(),
                    'emotionalIntensities': moment.emotionalIntensities
                        .map((e) => {
                              'emotion': e.emotion.name,
                              'intensity': e.intensity,
                            })
                        .toList(),
                    'medias': moment.medias
                        .map((media) => {
                              'path': media.path,
                            })
                        .toList(),
                  })
              .toList(),
        };
      }).toList(),
      'firstDay': state.firstDay?.toIso8601String(),
    };
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
