import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isCalendarMode;

  const SettingsState({
    this.isCalendarMode = true,
  });

  @override
  List<Object?> get props => [isCalendarMode];

  SettingsState copyWith({
    bool? isCalendarMode,
  }) {
    return SettingsState(
      isCalendarMode: isCalendarMode ?? this.isCalendarMode,
    );
  }
}
