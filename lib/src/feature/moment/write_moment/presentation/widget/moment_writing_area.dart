import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/write_moment_bloc.dart';
import '../../application/write_moment_event.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

class MomentWritingArea extends StatelessWidget {
  const MomentWritingArea({
    super.key,
    required TextEditingController controller,
    required this.mode,
    required this.focusNode,
  }) : _controller = controller;

  final TextEditingController _controller;
  final WriteMode mode;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        focusNode: focusNode,
        scrollPadding: const EdgeInsets.all(0),
        maxLines: null,
        minLines: null,
        expands: true,
        controller: _controller,
        maxLength: 600,
        enabled: mode != WriteMode.view,
        autofocus: mode != WriteMode.view,
        decoration: InputDecoration(
            hintText: ([
              AppLocalizations.of(context)!.writeDiaryHint1,
              AppLocalizations.of(context)!.writeDiaryHint2,
              AppLocalizations.of(context)!.writeDiaryHint3,
              AppLocalizations.of(context)!.writeDiaryHint4,
              AppLocalizations.of(context)!.writeDiaryHint5,
              AppLocalizations.of(context)!.writeDiaryHint6,
              AppLocalizations.of(context)!.writeDiaryHint7,
              AppLocalizations.of(context)!.writeDiaryHint8,
              AppLocalizations.of(context)!.writeDiaryHint9,
              AppLocalizations.of(context)!.writeDiaryHint10,
              AppLocalizations.of(context)!.writeDiaryHint11,
            ]..shuffle())
                .first,
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            counterStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: "Pretendard",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                )),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: "Pretendard",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.32,
              height: 1.25,
              color: const Color(0xFF4D5E58),
            ),
        onChanged: (String text) {
          context.read<WriteMomentBloc>().add(TextChangedEvent(text));
        },
        onSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTapOutside: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
