import 'package:flutter/material.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

class MomentWritingPageTitle extends StatelessWidget {
  const MomentWritingPageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.writeDiaryGuide,
          style: const TextStyle(
            fontFamily: "Pretendard",
            fontSize: 16,
            height: 1.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.32,
            color: Color(0xFF53545B),
          ),
        ),
      ],
    );
  }
}
