import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';

class MomentCalendarState extends Equatable {
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final DateTime? selectedPage;

  const MomentCalendarState({
    this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
    this.selectedPage,
  });

  @override
  List<Object?> get props => [selectedDay, calendarFormat, selectedPage];

  MomentCalendarState copyWith({
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
    DateTime? selectedPage,
  }) {
    return MomentCalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      selectedPage: selectedPage ?? this.selectedPage,
    );
  }
}
