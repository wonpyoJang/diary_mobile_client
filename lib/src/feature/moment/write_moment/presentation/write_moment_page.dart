import 'dart:ui';

import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/common/loading_indicator.dart';
import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_event.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_blending_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_palette.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/title.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/verification_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../../../injection.dart';
import '../../domain/entity/moment.dart';
import '../application/write_moment_bloc.dart';
import '../application/write_moment_state.dart';
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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller.value =
        TextEditingValue(text: widget.arguments.moment?.reflection ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WriteMomentBloc>(
          param1: widget.arguments.moment, param2: widget.arguments.date),
      child: Builder(builder: (context) {
        return Material(
          child: Stack(
            children: [
              // Image.asset(
              //   "assets/images/common/background/background.png",
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height,
              //   fit: BoxFit.cover,
              // ),
              Positioned.fill(child: Container(color: const Color(0xFFD3D3D3))),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.08,
                  child: Image.asset(
                    "assets/images/common/background/background.png", // 이미지 경로
                    colorBlendMode: BlendMode.overlay,
                    fit: BoxFit.cover, // 100% 100% 대응
                    alignment:
                        const Alignment(-0.03, 0.0), // -1.523px에 해당하는 정렬값 근사치
                  ),
                ),
              ),
              // 오버레이용 blend 효과 레이어

              // const Align(
              //     alignment: Alignment.topCenter, child: PaperTextureOverlay()),
              SafeArea(
                child: MultiBlocListener(
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
                        return prev.isLoading == true &&
                            next.moment.emotionalIntensities.isEmpty;
                      },
                      listener: (context, state) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("드러난 감정이 없습니다."),
                          ),
                        );
                      },
                    ),
                    BlocListener<WriteMomentBloc, WriteMomentState>(
                      listenWhen: (prev, next) {
                        return prev.mode != next.mode &&
                            next.mode == WriteMode.edit;
                      },
                      listener: (context, state) {
                        Future.delayed(const Duration(microseconds: 400), () {
                          _focusNode.requestFocus();
                        });
                      },
                    )
                  ],
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                HeaderArea(
                                  date: widget.arguments.date,
                                  screenshotController: _screenshotController,
                                ),
                                const SizedBox(height: 17),
                                Expanded(
                                  child: BlocBuilder<WriteMomentBloc,
                                      WriteMomentState>(
                                    builder: (context, state) {
                                      return MomentWritingArea(
                                          focusNode: _focusNode,
                                          controller: _controller,
                                          mode: state.mode);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 104),
                                // BlocBuilder<WriteMomentBloc, WriteMomentState>(
                                //   builder: (context, state) {
                                //     if (state
                                //         .moment.emotionalIntensities.isEmpty) {
                                //       return const SizedBox(height: 23);
                                //     } else {
                                //       return Padding(
                                //         padding: const EdgeInsets.only(
                                //             top: 15.0, bottom: 29),
                                //         child: Screenshot(
                                //           controller: _screenshotController,
                                //           child: EmotionPalette(
                                //               emotionalIntensities: state
                                //                   .moment.emotionalIntensities),
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          BlocBuilder<WriteMomentBloc, WriteMomentState>(
                            builder: (context, state) {
                              if (state.mode != WriteMode.view) {
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 30, right: 27),
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF956C),
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                        ),
                                        child: Center(
                                            child: SvgPicture.asset(
                                                "assets/images/feature/moment/write_moment/next.svg")),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Align(
                                  alignment: Alignment.bottomRight,
                                  child: ExtractEmotionButon(),
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
              BlocBuilder<WriteMomentBloc, WriteMomentState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CommonLoadingIndicator());
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
        );
      }),
    );
  }
}

class HeaderArea extends StatelessWidget {
  final DateTime date;
  final ScreenshotController screenshotController;
  const HeaderArea(
      {super.key, required this.date, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DateBox(date: date),
          const SizedBox(width: 4.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<WriteMomentBloc, WriteMomentState>(
                  builder: (context, state) {
                    if (state.moment.emotionalIntensities.isNotEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              EmotionList(
                                  emotionalIntensies:
                                      state.moment.emotionalIntensities),
                              if (state.moment.emotionalIntensities.length >
                                      4 ||
                                  true) ...[
                                const SizedBox(width: 9),
                                InkWell(
                                  onTap: () async {
                                    await verificationDialog(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: SizedBox(
                                        child: Text(
                                      "more +",
                                      style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF959490),
                                        height: 2,
                                        letterSpacing: -0.24,
                                      ),
                                    )),
                                  ),
                                )
                              ]
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: PullDownButton(
                                itemBuilder: (context) => [
                                      if (state.mode == WriteMode.view)
                                        PullDownMenuItem(
                                          title: '수정하기',
                                          onTap: () {
                                            context
                                                .read<WriteMomentBloc>()
                                                .add(const ChangeToEdit());
                                          },
                                        ),
                                      PullDownMenuItem(
                                        title: '삭제하기',
                                        onTap: () {
                                          showYesOrNoDialog(context,
                                              title: "삭제하시겠습니까?",
                                              onConfirm: (value) {
                                            context.read<MomentListBloc>().add(
                                                DeleteMoment(state.moment));
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                      PullDownMenuItem(
                                        title: '공유하기',
                                        onTap: () async {
                                          AnalyticsManager.logEvent(
                                              'editor_share_emotion');
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
                                                        Navigator.of(context)
                                                            .pop();
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
                                                await screenshotController
                                                    .capture();
                                            if (image != null) {
                                              final directory =
                                                  await getApplicationDocumentsDirectory();
                                              final timestamp = DateTime.now()
                                                  .millisecondsSinceEpoch;
                                              final imagePath = File(
                                                  '${directory.path}/emotion_palette_$timestamp.png');
                                              await imagePath
                                                  .writeAsBytes(image);
                                              await Share.shareXFiles(
                                                  [XFile(imagePath.path)],
                                                  text:
                                                      '오늘의 기분을 공유합니다.\n\n[${DateTime.now().month}월 ${DateTime.now().day}일의 일기]\n${state.moment.reflection}');
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                buttonBuilder: (context, showMenu) {
                                  return MenuButton(
                                    onTap: showMenu,
                                  );
                                }),
                          )
                        ],
                      );
                    } else {
                      return const MomentWritingPageTitle();
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                    height: 1,
                    width: double.infinity,
                    color: const Color(0xFF7F7F7F))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final Function onTap;
  const MenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFF3E9E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              ...[1, 2, 3].map((e) => Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF956C),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ))
            ],
          ))),
    );
  }
}

class EmotionList extends StatelessWidget {
  final List<EmotionalIntensity> emotionalIntensies;
  final MainAxisAlignment mainAxisAlignment;
  const EmotionList(
      {super.key,
      required this.emotionalIntensies,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...emotionalIntensies.take(4).map((e) => EmotionItem(
              size: EmotionItemSize.small,
              emotionalIntensity: e,
            ))
      ],
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

    return SizedBox(
      width: 59,
      height: 56,
      child: Center(
        child: Text(
            "$monthFirstDigit $monthSecondDigit\n$dayFirstDigit $daySecondDigit",
            style: const TextStyle(
              color: Color(0xFF53545B),
              fontSize: 28,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: -0.24,
              fontFamily: "SpoqaHanSansNeo",
            )),
      ),
    );
  }
}

// class PaperTextureOverlay extends StatelessWidget {
//   const PaperTextureOverlay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 360,
//         height: 640,
//         child: RotatedBox(
//           quarterTurns: 3, // -90도 회전
//           child: Stack(
//             children: [
//               Container(color: Colors.grey[300]), // lightgray 배경

//               // 종이 질감 레이어
//               Positioned.fill(
//                 child: FractionallySizedBox(
//                   widthFactor: 1.01121, // 101.121%
//                   heightFactor: 1.0,
//                   alignment: const Alignment(-0.0085 * 2, 0), // -1.523px 위치 조정
//                   child: ColorFiltered(
//                     colorFilter: const ColorFilter.mode(
//                       Colors.white,
//                       BlendMode.overlay, // CSS의 mix-blend-mode: overlay 대체
//                     ),
//                     child: ImageFiltered(
//                       imageFilter:
//                           ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2), // 부드러운 처리
//                       child: Image.asset(
//                         "assets/images/common/background/background.png",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
