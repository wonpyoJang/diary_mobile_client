import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_state.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> verificationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: BlocProvider.of<WriteMomentBloc>(context),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("오늘은 다양한 감정이\n느껴지는 하루에요",
                  style: TextStyle(
                    color: Color(0xFF4D4E58),
                    fontFamily: "SpoqaHanSansNeo",
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -0.4,
                  )),
              const SizedBox(height: 20),
              BlocBuilder<WriteMomentBloc, WriteMomentState>(
                builder: (context, state) {
                  return EmotionPalette(
                      emotionalIntensities: state.moment.emotionalIntensities);
                },
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("이 분석이 맞나요?",
                            style: TextStyle(
                                color: Color(0xFF4D4E58),
                                fontFamily: "SpoqaHanSansNeo",
                                fontSize: 16,
                                letterSpacing: 0.32)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        AnalyticsManager.logEvent(
                            'editor_right_emotion_not_match');
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFADCBFF),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text('달라요 👎',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontFamily: "SpoqaHanSansNeo",
                                      letterSpacing: -0.32,
                                      color: const Color(0xFF4D4E58))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        AnalyticsManager.logEvent('editor_right_emotion_match');
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFADCBFF),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text('맞아요 👍',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontFamily: "SpoqaHanSansNeo",
                                      letterSpacing: -0.32,
                                      color: const Color(0xFF4D4E58))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
