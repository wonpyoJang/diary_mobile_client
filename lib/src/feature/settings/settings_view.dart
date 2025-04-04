import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_event.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_state.dart';
import 'package:diary_mobile_client/src/feature/splash/splash_page.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            title: const Text('Settings'),
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
                        child: Text('System Theme',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color))),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color)),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color)),
                    )
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
                      Text('실험실',
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
                              const Text('캘린더 모드',
                                  style: TextStyle(fontSize: 16)),
                              Switch(
                                value: state.isCalendarMode,
                                onChanged: (bool value) {
                                  showYesOrNoDialog(context,
                                      title: '캘린더 모드',
                                      message: state.isCalendarMode
                                          ? '캘린더 모드를 해제하시겠습니까?\n캘린더 모드를 해제하면 앱을 재시작합니다.'
                                          : '캘린더 모드로 변경하시겠습니까?\n캘린더 모드로 변경하면 앱을 재시작합니다.',
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
