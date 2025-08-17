import 'package:diary_mobile_client/src/feature/settings/configurations/language/presentation/language_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  static const routeName = '/terms';

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.termsAndPrivacy),
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
                title: Text(AppLocalizations.of(context)!.terms),
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
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .privacyPolicy), // TODO: privacyPolicy 키 추가 필요
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: 약관 페이지로 이동
                },
              ),
              const SizedBox(height: 1),
            ],
          ),
        ),
      );
    });
  }
}
