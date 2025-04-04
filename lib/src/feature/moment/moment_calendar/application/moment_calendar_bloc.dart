import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'moment_calendar_event.dart';
import 'moment_calendar_state.dart';

@injectable
class MomentCalendarBloc
    extends Bloc<MomentCalendarEvent, MomentCalendarState> {
  MomentCalendarBloc()
      : super(MomentCalendarState(selectedDay: DateTime.now())) {
    on<SelectDay>((event, emit) {
      emit(state.copyWith(selectedDay: event.date));
    });

    on<ChangePage>((event, emit) {
      emit(state.copyWith(selectedPage: event.date));
    });

    on<ChangeCalendarFormat>((event, emit) {
      emit(state.copyWith(calendarFormat: event.calendarFormat));
    });
  }
}
