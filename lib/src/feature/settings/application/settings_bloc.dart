import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleCalendarMode>((event, emit) {
      emit(state.copyWith(isCalendarMode: !state.isCalendarMode));
    });
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isCalendarMode: json['isCalendarMode'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {
      'isCalendarMode': state.isCalendarMode,
    };
  }
}
