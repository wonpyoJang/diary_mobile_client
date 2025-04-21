import 'dart:io';

import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/core/multi_device/screen_util.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/mesh_gradient/mesh_gradient_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entity/moment.dart';

Future<dynamic> showEmotionBlending(BuildContext context, Moment moment) {
  final screenshotController = ScreenshotController();

  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFFF6F6F6),
      insetPadding: ScreenUtil.isLandscape(context)
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: ScreenUtil.getAdaptiveSize(context,
            phone: 272, tablet: null, desktop: null),
        height: 428,
        child: Screenshot(
          controller: screenshotController,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "오늘의 감정",
                  style: TextStyle(
                      color: Color(0xFF808080),
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      letterSpacing: -0.32),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (ScreenUtil.isLandscape(context) == true)
                            AspectRatio(
                              aspectRatio: 1,
                              child: MeshGradientView(moment: moment),
                            )
                          else
                            SizedBox(
                                width: 240,
                                height: 288,
                                child: MeshGradientView(moment: moment)),
                          if (ScreenUtil.isLandscape(context) == true) ...[
                            const SizedBox(width: 16),
                            Expanded(
                                child: ContentPanel(
                                    screenshotController: screenshotController))
                          ]
                        ],
                      ),
                      if (ScreenUtil.isLandscape(context) == false) ...[
                        const SizedBox(height: 16),
                        ContentPanel(screenshotController: screenshotController)
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class ContentPanel extends StatelessWidget {
  final ScreenshotController screenshotController;
  const ContentPanel({super.key, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                AnalyticsManager.logEvent('emotion_blending_save_image');

                final image = await screenshotController.capture();
                if (image != null) {
                  // 이미지 저장 로직 추가
                  if (kIsWeb && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림'),
                          content: const Text(
                              '웹에서는 이미지를 저장할 수 없습니다.\n앱 다운로드 링크: https://testflight.apple.com/join/9Z7cKQSj'),
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
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    late PermissionStatus status;

                    if (Platform.isAndroid) {
                      status = await Permission.photos.request();
                    } else {
                      status = await Permission.storage.request();
                    }

                    if (status.isGranted) {
                      try {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final timestamp = DateTime.now().millisecondsSinceEpoch;
                        final imagePath =
                            await File('${directory.path}/image_$timestamp.png')
                                .create();
                        await imagePath.writeAsBytes(image);

                        await ImageGallerySaverPlus.saveImage(image);

                        if (context.mounted) {
                          AnalyticsManager.logEvent(
                              'emotion_blending_save_image_success');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('이미지가 성공적으로 저장되었습니다.'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AnalyticsManager.logEvent(
                              'emotion_blending_save_image_error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('이미지 저장 중 오류가 발생했습니다: $e'),
                            ),
                          );
                        }
                      }
                    } else {
                      if (context.mounted) {
                        AnalyticsManager.logEvent(
                            'emotion_blending_save_image_permission_denied');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: InkWell(
                                onTap: () {
                                  openAppSettings();
                                },
                                child: const Text('갤러리 쓰기 권한이 필요합니다.')),
                          ),
                        );
                      }
                    }
                  }

                  // /// Share Plugin
                  // await Share.shareFiles([imagePath.path]);
                }
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E9E5),
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Center(
                    child: SvgPicture.asset(
                        "assets/images/feature/moment/write_moment/download.svg")),
              ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF956C),
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Center(
                    child: SvgPicture.asset(
                        "assets/images/feature/moment/write_moment/next.svg")),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}
