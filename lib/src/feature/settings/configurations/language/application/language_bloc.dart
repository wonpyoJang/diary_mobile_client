import 'package:diary_mobile_client/src/feature/settings/settings_controller.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  @override
  List<Object?> get props => [locale];

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(locale: locale ?? this.locale);
  }
}

@injectable
class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit(this.controller)
      : super(const LanguageState(locale: Locale('ko')));

  final SettingsController controller;

  Future<void> changeLanguage(Locale locale) async {
    await controller.updateLocale(locale);
    emit(state.copyWith(locale: locale));
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    final String? languageCode = json['languageCode'] as String?;
    final String? countryCode = json['countryCode'] as String?;
    if (languageCode == null) return null;
    return LanguageState(
      locale: countryCode == null || countryCode.isEmpty
          ? Locale(languageCode)
          : Locale(languageCode, countryCode),
    );
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return {
      'languageCode': state.locale.languageCode,
      'countryCode': state.locale.countryCode ?? '',
    };
  }
}
