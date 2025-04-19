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
      child: SizedBox(
        width: 272,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            child: SizedBox(
              width: 272,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 29,
                    child: Center(
                      child: Text("오늘의 감정",
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontFamily: "Pretendard",
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.32,
                          )),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1, color: Color(0xFF808080)),
                      bottom: BorderSide(width: 1, color: Color(0xFF808080)),
                    )),
                    child: BlocBuilder<WriteMomentBloc, WriteMomentState>(
                      builder: (context, state) {
                        return EmotionPalette(
                            emotionalIntensities:
                                state.moment.emotionalIntensities);
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(
                    height: 29,
                    child: Center(
                      child: Text("이 분석이 맞나요?",
                          style: TextStyle(
                              color: Color(0xFF808080),
                              fontFamily: "SpoqaHanSansNeo",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.32)),
                    ),
                  ),
                  const SizedBox(height: 6),
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
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF956C),
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
                                          color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(dialogContext);
                            AnalyticsManager.logEvent(
                                'editor_right_emotion_match');
                          },
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF956C),
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
                                          color: Colors.white)),
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
      ),
    ),
  );
}
