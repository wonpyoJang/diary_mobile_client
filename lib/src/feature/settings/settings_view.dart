import 'package:diary_mobile_client/src/feature/data_control/application/data_control_bloc.dart';
import 'package:diary_mobile_client/src/feature/data_control/application/data_control_event.dart';
import 'package:diary_mobile_client/src/feature/data_control/application/data_control_state.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/backup_page.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/language/presentation/language_setting_page.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/version/application/version_bloc.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_bloc.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_event.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart' hide LockState;
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: -0.8,
                  color: Color(0xFF53545B),
                )),
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
                  title: Text(
                    AppLocalizations.of(context)!.languageSetting,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.4,
                      color: Color(0xFF53545B),
                    ),
                  ),
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
                BlocBuilder<LockCubit, LockState>(
                  builder: (context, state) {
                    return ListTile(
                      title: const Text(
                        '잠금화면 설정',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: -0.4,
                          color: Color(0xFF53545B),
                        ),
                      ),
                      trailing: Switch(
                        value: state.isLockEnabled,
                        onChanged: (bool value) {
                          if (value) {
                            context.read<LockCubit>().setLockEnabled(value);
                          } else {
                            context.read<LockCubit>().setLockDisabled();
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 1),
                BlocBuilder<DataControlBloc, DataControlState>(
                  builder: (context, state) {
                    return ListTile(
                      title: const Text(
                        '데이터 서버 전송 여부',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: -0.4,
                          color: Color(0xFF53545B),
                        ),
                      ),
                      trailing: Switch(
                        value: state.allowedSendDataToServer,
                        onChanged: (bool value) {
                          if (value) {
                            context
                                .read<DataControlBloc>()
                                .add(SetSendDataToServer());
                          } else {
                            context
                                .read<DataControlBloc>()
                                .add(UnsetSendDataToServer());
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 1),
                ListTile(
                  title: const Text("백업 설정"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BackupPage()));
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.termsAndPrivacy,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.4,
                      color: Color(0xFF53545B),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: 약관 페이지로 이동
                  },
                ),
                const SizedBox(height: 1),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.version,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.4,
                      color: Color(0xFF53545B),
                    ),
                  ),
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
                const SizedBox(height: 1),
                ListTile(
                  title: const Text(
                    "로그아웃",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.4,
                      color: Color(0xFF53545B),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.read<UserBloc>().add(SignOut());
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
