import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/language/presentation/language_setting_page.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/version/application/version_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<VersionBloc>()..fetchVersionInfo(),
        ),
      ],
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
                ListTile(
                  title: Text(AppLocalizations.of(context)!.languageSetting),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageSettingPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 1),
                // 언어 선택 드롭다운
                ListTile(
                  title: Text(AppLocalizations.of(context)!.version),
                  subtitle: BlocBuilder<VersionBloc, VersionState>(
                    builder: (context, state) {
                      if (state is VersionLoaded) {
                        return Text('${state.version} (${state.buildNumber})');
                      } else if (state is VersionError) {
                        return Text(
                            AppLocalizations.of(context)!.versionLoadError,
                            style: const TextStyle(color: Colors.red));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
