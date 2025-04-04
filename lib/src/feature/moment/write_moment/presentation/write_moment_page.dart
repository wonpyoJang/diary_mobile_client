import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_blending_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/title.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/verification_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../../../injection.dart';
import '../../domain/entity/moment.dart';
import '../application/write_moment_bloc.dart';
import '../application/write_moment_state.dart';
import 'widget/emotion_palette.dart';
import 'widget/extract_emotion_button.dart';
import 'widget/moment_writing_area.dart';

class WriteMomentPageArguments {
  final Moment? moment;
  final bool isBlendMode;
  final DateTime date;

  WriteMomentPageArguments(
      {this.moment, this.isBlendMode = false, required this.date});
}

class WriteMomentPage extends StatefulWidget {
  final WriteMomentPageArguments arguments;
  const WriteMomentPage({super.key, required this.arguments});

  static const routeName = '/moment/write';

  @override
  WriteMomentPageState createState() => WriteMomentPageState();
}

class WriteMomentPageState extends State<WriteMomentPage> {
  final TextEditingController _controller = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    _controller.value =
        TextEditingValue(text: widget.arguments.moment?.reflection ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => getIt<WriteMomentBloc>(
            param1: widget.arguments.moment, param2: widget.arguments.date),
        child: Builder(builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<WriteMomentBloc, WriteMomentState>(
                listenWhen: (prev, next) {
                  return (prev.errorMessage != next.errorMessage) &&
                      (next.errorMessage.isNotEmpty);
                },
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
                },
              ),
              if (widget.arguments.isBlendMode)
                BlocListener<WriteMomentBloc, WriteMomentState>(
                  listenWhen: (prev, next) {
                    return prev.moment.emotionalIntensities !=
                            next.moment.emotionalIntensities &&
                        next.moment.emotionalIntensities.length > 1;
                  },
                  listener: (context, state) async {
                    await verificationDialog(context);

                    if (context.mounted) {
                      await showEmotionBlending(context, state.moment);
                    }
                  },
                ),
              BlocListener<WriteMomentBloc, WriteMomentState>(
                listenWhen: (prev, next) {
                  return next.moment.emotionalIntensities.isEmpty;
                },
                listener: (context, state) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("드러난 감정이 없습니다."),
                    ),
                  );
                },
              )
            ],
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    DateBox(date: widget.arguments.date),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 12.0, bottom: 3),
                                      child: MomentWritingPageTitle(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 17),
                                MomentWritingArea(
                                    controller: _controller,
                                    mode: widget.arguments.moment != null
                                        ? WriteMode.edit
                                        : WriteMode.create),
                                BlocBuilder<WriteMomentBloc, WriteMomentState>(
                                  builder: (context, state) {
                                    if (state
                                        .moment.emotionalIntensities.isEmpty) {
                                      return const SizedBox(height: 23);
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, bottom: 29),
                                        child: Screenshot(
                                          controller: _screenshotController,
                                          child: EmotionPalette(
                                              emotionalIntensities: state
                                                  .moment.emotionalIntensities),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<WriteMomentBloc, WriteMomentState>(
                    builder: (context, state) {
                      if (state.moment.emotionalIntensities.isNotEmpty) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () async {
                              AnalyticsManager.logEvent('editor_share_emotion');
                              if (kIsWeb) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('알림'),
                                      content: const Text(
                                          '웹에서는 지원하지 않는 기능입니다.\n앱 다운로드 링크: https://testflight.apple.com/join/9Z7cKQSj'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('확인'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('다운로드'),
                                          onPressed: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'https://testflight.apple.com/join/9Z7cKQSj'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                final image =
                                    await _screenshotController.capture();
                                if (image != null) {
                                  final directory =
                                      await getApplicationDocumentsDirectory();
                                  final timestamp =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final imagePath = File(
                                      '${directory.path}/emotion_palette_$timestamp.png');
                                  await imagePath.writeAsBytes(image);
                                  await Share.shareXFiles(
                                      [XFile(imagePath.path)],
                                      text:
                                          '오늘의 기분을 공유합니다.\n\n[${DateTime.now().month}월 ${DateTime.now().day}일의 일기]\n${state.moment.reflection}');
                                }
                              }
                            },
                            child: Container(
                              height: 60,
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFADCBFF),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                  child: Text('오늘의 기분 공유하기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontSize: 20,
                                              letterSpacing: -0.4,
                                              color: const Color(0xFF4D4E58)))),
                            ),
                          ),
                        );
                      } else {
                        return const Align(
                          alignment: Alignment.bottomCenter,
                          child: ExtractEmotionButon(),
                        );
                      }
                    },
                  ),
                  BlocBuilder<WriteMomentBloc, WriteMomentState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final DateTime date;
  const DateBox({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final month = date.month;
    final day = date.day;

    final monthStr = month.toString().padLeft(2, '0');
    final monthFirstDigit = monthStr[0];
    final monthSecondDigit = monthStr[1];

    final dayStr = day.toString().padLeft(2, '0');
    final dayFirstDigit = dayStr[0];
    final daySecondDigit = dayStr[1];

    return Text(
        "$monthFirstDigit $monthSecondDigit\n$dayFirstDigit $daySecondDigit",
        style: const TextStyle(
          color: Color(0xFF4D4E58),
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: -0.24,
          fontFamily: "SpoqaHanSansNeo",
        ));
  }
}
