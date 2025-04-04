import 'dart:io';

import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/mesh_gradient/mesh_gradient_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Screenshot(
        controller: screenshotController,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kIsWeb && MediaQuery.of(context).size.width > 400
                      ? 300
                      : (MediaQuery.of(context).size.width - 80) * (335 / 280),
                  width: kIsWeb && MediaQuery.of(context).size.width > 400
                      ? 300
                      : MediaQuery.of(context).size.width - 80,
                  child: MeshGradientView(moment: moment),
                ),
                const SizedBox(height: 20),
                const Text(
                  "오늘은 다채로운 하루를\n보내셨네요.",
                  style: TextStyle(
                    fontFamily: "SpocaHanSansNeo",
                    fontSize: 24,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4D4E58),
                  ),
                ),
                const SizedBox(height: 20),
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
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          try {
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final timestamp =
                                DateTime.now().millisecondsSinceEpoch;
                            final imagePath = await File(
                                    '${directory.path}/image_$timestamp.png')
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
                              const SnackBar(
                                content: Text('갤러리 쓰기 권한이 필요합니다.'),
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
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFADCBFF),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                        child: Text('오늘의 기분 저장하기',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                    color: const Color(0xFF4D4E58)))),
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
