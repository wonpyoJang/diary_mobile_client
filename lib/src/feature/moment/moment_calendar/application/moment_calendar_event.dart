import 'package:equatable/equatable.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class MomentCalendarEvent extends Equatable {
  const MomentCalendarEvent();

  @override
  List<Object?> get props => [];
}

class SelectDay extends MomentCalendarEvent {
  final DateTime date;

  const SelectDay(this.date);
}

class ChangePage extends MomentCalendarEvent {
  final DateTime date;

  const ChangePage(this.date);
}

class ChangeCalendarFormat extends MomentCalendarEvent {
  final CalendarFormat calendarFormat;

  const ChangeCalendarFormat(this.calendarFormat);
}
