// TODO: Wire from AI feature entry points (e.g., weekly summary, trigger
// analysis). Track A's LlmRouter can call this if it has access to the
// navigator. The intended flow is:
//   1. AI feature entry point calls `LlmDialogTrigger.maybeShow(context)`.
//   2. The trigger checks `ILlmSettingsRepository.hasSeenOptInDialog()`.
//   3. If unseen, it shows the opt-in dialog and waits for the user choice.
//   4. After the dialog flow finishes, the AI feature proceeds to call
//      `LlmRouter.generate(...)` (Track A).

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../presentation/widgets/llm_optin_dialog.dart';

@lazySingleton
class LlmDialogTrigger {
  const LlmDialogTrigger();

  /// Shows the opt-in dialog if the user has not yet seen it.
  /// Returns once the dialog flow (or the no-op path) completes.
  Future<void> maybeShow(BuildContext context) async {
    await LlmOptInDialog.showIfFirstTime(context);
  }
}
