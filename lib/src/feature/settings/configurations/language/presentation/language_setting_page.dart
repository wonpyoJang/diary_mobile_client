import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/language/application/language_bloc.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => getIt<LanguageCubit>(),
      child: Builder(builder: (context) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            final selectedLocale = state.locale;
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.languageSetting),
              ),
              body: ListView(
                children: [
                  _buildLanguageTile(
                      context, selectedLocale, const Locale('ko'), '한국어'),
                  _buildLanguageTile(
                      context, selectedLocale, const Locale('en'), 'English'),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context, Locale selected, Locale locale, String title) {
    final isSelected = selected.languageCode == locale.languageCode;
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        if (!isSelected) {
          context.read<LanguageCubit>().changeLanguage(locale);
        }
      },
    );
  }
}
