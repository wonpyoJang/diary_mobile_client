// Wired from AI feature entry points. The flow is:
//   1. AI feature entry point calls `LlmDialogTrigger.maybeShow(context)`.
//   2. The trigger checks `ILlmSettingsRepository.hasSeenOptInDialog()`.
//   3. If unseen, it shows the opt-in dialog and waits for the user choice.
//   4. After the dialog flow finishes, the AI feature proceeds to call
//      `LlmRouter.generate(...)` (Track A).
//
// Current call sites:
//   - `extract_emotion_button.dart` (before dispatching `Analyzed`).
//   - `write_moment_page.dart` add-image confirm (before dispatching
//     `WriteByImage`).

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
