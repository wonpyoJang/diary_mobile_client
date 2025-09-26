import 'dart:io';

import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/write_moment_state.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/menu_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WritePageMenus extends StatelessWidget {
  const WritePageMenus({
    super.key,
    required this.screenshotController,
  });

  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriteMomentBloc, WriteMomentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 9.0),
          child: PullDownButton(
              itemBuilder: (context) => [
                    if (state.mode == WriteMode.view)
                      PullDownMenuItem(
                        title: AppLocalizations.of(context)!.edit,
                        onTap: () {
                          context
                              .read<WriteMomentBloc>()
                              .add(const ChangeToEdit());
                        },
                      ),
                    PullDownMenuItem(
                      title: AppLocalizations.of(context)!.addPhoto,
                      onTap: () async {
                        context.read<WriteMomentBloc>().add(const AddMedias());
                      },
                    ),
                    PullDownMenuItem(
                      title: AppLocalizations.of(context)!.delete,
                      onTap: () {
                        showYesOrNoDialog(context,
                            title: AppLocalizations.of(context)!.deleteConfirm,
                            onConfirm: (value) {
                          context
                              .read<MomentListBloc>()
                              .add(DeleteMoment(state.moment));
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    PullDownMenuItem(
                      title: AppLocalizations.of(context)!.share,
                      onTap: () async {
                        AnalyticsManager.logEvent('editor_share_emotion');
                        if (kIsWeb) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context)!.notification),
                                content: Text(
                                    "${AppLocalizations.of(context)!.webNotSupported}\n${AppLocalizations.of(context)!.appDownloadLink}"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.confirm),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.download),
                                    onPressed: () {
                                      launchUrl(
                                        Uri.parse(AppLocalizations.of(context)!
                                            .appDownloadLink),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          final image = await screenshotController.capture();
                          if (image != null) {
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final timestamp =
                                DateTime.now().millisecondsSinceEpoch;
                            final imagePath = File(
                                '${directory.path}/emotion_palette_$timestamp.png');
                            await imagePath.writeAsBytes(image);
                            if (context.mounted == false) return;
                            await Share.shareXFiles(
                              [XFile(imagePath.path)],
                              // ignore: prefer_interpolation_to_compose_strings
                              text: AppLocalizations.of(context)!.shareEmotion +
                                  '\n\n' +
                                  '${AppLocalizations.of(context)!.diaryReflection}${DateTime.now().month}월 ${DateTime.now().day}일\n${state.moment.reflection}',
                            );
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
        );
      },
    );
  }
}
