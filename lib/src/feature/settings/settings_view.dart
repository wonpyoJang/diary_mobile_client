import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_event.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_state.dart';
import 'package:diary_mobile_client/src/feature/splash/splash_page.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<ThemeMode>(
                  // Read the selected themeMode from the controller
                  value: controller.themeMode,
                  // Call the updateThemeMode method any time the user selects a theme.
                  onChanged: controller.updateThemeMode,
                  items: [
                    DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(AppLocalizations.of(context)!.systemTheme,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color))),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(AppLocalizations.of(context)!.lightTheme,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color)),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(AppLocalizations.of(context)!.darkTheme,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color)),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                // 언어 선택 드롭다운
                DropdownButton<Locale>(
                  value: controller.locale ?? const Locale('ko'),
                  onChanged: (Locale? newLocale) {
                    controller.updateLocale(newLocale);
                  },
                  items: [
                    DropdownMenuItem(
                      value: const Locale('ko'),
                      child: Text(
                        '한국어',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text(
                        'English',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                // 실험실 타일
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.lab,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 8),
                      BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.calendarMode,
                                  style: const TextStyle(fontSize: 16)),
                              Switch(
                                value: state.isCalendarMode,
                                onChanged: (bool value) {
                                  showYesOrNoDialog(context,
                                      title: AppLocalizations.of(context)!
                                          .calendarMode,
                                      message: state.isCalendarMode
                                          ? "${AppLocalizations.of(context)!.calendarMode}를 해제하시겠습니까?\n캘린더 모드를 해제하면 앱을 재시작합니다."
                                          : "${AppLocalizations.of(context)!.calendarMode}로 변경하시겠습니까?\n캘린더 모드로 변경하면 앱을 재시작합니다.",
                                      onConfirm: (bool value) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(const ToggleCalendarMode());
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SplashPage()));
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
