import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
@singleton
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Loads the User's preferred Locale from local or remote storage.
  Future<Locale?> locale() async {
    // TODO: 실제 저장소에서 불러오도록 구현 (예: shared_preferences)
    return null; // null이면 시스템 언어 사용
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  /// Persists the user's preferred Locale to local or remote storage.
  Future<void> updateLocale(Locale locale) async {
    // TODO: 실제 저장소에 저장하도록 구현 (예: shared_preferences)
  }
}
