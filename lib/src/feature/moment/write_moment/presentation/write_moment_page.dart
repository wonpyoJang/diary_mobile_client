// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:diary_mobile_client/src/feature/common/image_viewer.dart';
import 'package:diary_mobile_client/src/feature/common/loading_indicator.dart';
import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/add_photo_button.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/date_box.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_blending_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_list.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/title.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/verification_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/write_page_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';

import '../../../../injection.dart';
import '../../../common/moment/domain/entity/moment.dart';
import '../application/write_moment_bloc.dart';
import '../application/write_moment_state.dart';
import 'widget/extract_emotion_button.dart';
import 'widget/moment_writing_area.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

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
        return MultiBlocListener(
          listeners: [
            BlocListener<WriteMomentBloc, WriteMomentState>(
              listenWhen: (prev, next) {
                return (prev.isLoading == true && next.isLoading == false) &&
                    (prev.moment.medias.length < next.moment.medias.length);
              },
              listener: (context, state) {
                if (state.mode == WriteMode.create ||
                    state.mode == WriteMode.edit) {
                  showYesOrNoDialog(
                    context,
                    title: AppLocalizations.of(context)!.addImageToWrite,
                    onConfirm: (value) {
                      context.read<WriteMomentBloc>().add(const WriteByImage());
                    },
                  );
                }
              },
            ),
            BlocListener<WriteMomentBloc, WriteMomentState>(
              listenWhen: (prev, next) {
                return prev.isTextGenerated == false &&
                    next.isTextGenerated == true;
              },
              listener: (context, state) {
                _controller.value = TextEditingValue(
                    text: state.moment.reflection,
                    selection: TextSelection.fromPosition(
                        TextPosition(offset: state.moment.reflection.length)));
                context
                    .read<WriteMomentBloc>()
                    .add(const ResetIsTextGenerated());
              },
            ),
            BlocListener<WriteMomentBloc, WriteMomentState>(
              listenWhen: (prev, next) {
                return prev.failure != null && next.failure == null;
              },
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failure!.message)),
                );
              },
            ),
          ],
          child: Material(
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(color: const Color(0xFFF6F6F6))),
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
                          // 분석이 완료된 후(isLoading이 false가 된 후)에 감정이 없을 때만 트리거
                          return prev.hasAnalyzed == false &&
                              next.hasAnalyzed == true &&
                              next.moment.emotionalIntensities.isEmpty;
                        },
                        listener: (context, state) async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.noEmotion),
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
                                  const SizedBox(height: 16),
                                  BlocBuilder<WriteMomentBloc,
                                      WriteMomentState>(
                                    builder: (context, state) {
                                      final medias = state.moment.medias;
                                      if (medias.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return SizedBox(
                                        height: 120,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: medias.length,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (context, index) {
                                            final media = medias[index];
                                            return Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageViewerPage(
                                                          imageUrls: medias
                                                              .map(
                                                                  (e) => e.path)
                                                              .toList(),
                                                          initialIndex: index,
                                                          title:
                                                              "${widget.arguments.date.month}월 ${widget.arguments.date.day}일",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.file(
                                                      File(media.path),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                // x 버튼(삭제 버튼) 추가
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showYesOrNoDialog(context,
                                                          title: AppLocalizations
                                                                  .of(context)!
                                                              .deleteConfirm,
                                                          onConfirm: (value) {
                                                        context
                                                            .read<
                                                                WriteMomentBloc>()
                                                            .add(DeleteMedia(
                                                                index));
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withAlpha(20),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 104),
                                ],
                              ),
                            ),
                            BlocBuilder<WriteMomentBloc, WriteMomentState>(
                              builder: (context, state) {
                                if (state.mode == WriteMode.view) {
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AddPhotoButton(),
                                        SizedBox(width: 8),
                                        ExtractEmotionButon(),
                                      ],
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
          ),
        );
      }),
    );
  }
}

class HeaderArea extends StatelessWidget {
  final DateTime date;
  final ScreenshotController screenshotController;
  const HeaderArea({
    super.key,
    required this.date,
    required this.screenshotController,
  });

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<WriteMomentBloc, WriteMomentState>(
                      builder: (context, state) {
                        if (state.moment.emotionalIntensities.isNotEmpty) {
                          return Row(
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
                          );
                        } else {
                          return const MomentWritingPageTitle();
                        }
                      },
                    ),
                    WritePageMenus(screenshotController: screenshotController)
                  ],
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
