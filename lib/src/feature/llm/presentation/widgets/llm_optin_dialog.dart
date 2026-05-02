import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';

import '../../domain/i_llm_settings_repository.dart';
import '../../domain/llm_settings.dart';
import '../llm_settings_page.dart';

class LlmOptInDialog {
  const LlmOptInDialog._();

  /// Shows the opt-in dialog the first time an AI feature is invoked.
  /// Subsequent calls are no-ops.
  static Future<void> showIfFirstTime(BuildContext context) async {
    final repository = getIt<ILlmSettingsRepository>();
    final hasSeen = await repository.hasSeenOptInDialog();
    if (hasSeen) return;
    if (!context.mounted) return;
    await _show(context, repository);
  }

  static Future<void> _show(
    BuildContext context,
    ILlmSettingsRepository repository,
  ) async {
    final navigator = Navigator.of(context, rootNavigator: true);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(dialogL10n.llmOptInDialogTitle),
          content: Text(dialogL10n.llmOptInDialogBody),
          actions: [
            TextButton(
              onPressed: () async {
                await repository.markOptInDialogSeen();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(dialogL10n.llmOptInButtonLater),
            ),
            TextButton(
              onPressed: () async {
                await repository.markOptInDialogSeen();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                navigator.pushNamed(LlmSettingsPage.routeName);
              },
              child: Text(dialogL10n.llmOptInButtonOnDevice),
            ),
            FilledButton(
              onPressed: () async {
                await repository.setMode(LlmMode.remote);
                await repository.markOptInDialogSeen();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(dialogL10n.llmOptInButtonRemote),
            ),
          ],
        );
      },
    );
  }
}
