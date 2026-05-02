import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

class CommonLoadingIndicator extends StatelessWidget {
  const CommonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withAlpha(128),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.extractingEmotion,
              style: const TextStyle(
                fontFamily: "Pretendard",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.32,
                color: Colors.white,
              )),
          const SizedBox(
            height: 40,
            child: LoadingIndicator(
                indicatorType: Indicator.ballPulseSync,
                colors: [
                  Color(0xFFEC7C61),
                  Color(0xFFBEBADC),
                  Color(0xFF93B1F3)
                ],
                strokeWidth: 2,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.black),
          ),
        ],
      ),
    );
  }
}
