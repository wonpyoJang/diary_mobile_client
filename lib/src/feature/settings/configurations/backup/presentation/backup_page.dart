import 'package:diary_mobile_client/src/feature/common/loading_indicator.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_state.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BackupPage extends StatelessWidget {
  static const routeName = '/backup';

  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BackupBloc>()..add(FetchICloudFiles()),
      child: Builder(builder: (context) {
        return BlocListener<BackupBloc, BackupState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.message)),
            );
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('백업 설정'),
            ),
            body: Stack(
              children: [
                ListView(
                  children: [
                    BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: const Text("백업하기"),
                          subtitle: state.lastBackupDate != null
                              ? Text(
                                  "마지막 백업일시: ${state.lastBackupDate != null ? DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초').format(state.lastBackupDate!.toLocal()) : ""}")
                              : const Text("마지막 백업일시가 없습니다."),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context.read<BackupBloc>().add(UploadBackup());
                          },
                        );
                      },
                    ),
                    BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: const Text("iCloud로 내보내기 (ZIP)"),
                          subtitle:
                              const Text("데이터베이스를 압축해 파일 앱을 통해 iCloud에 저장"),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context
                                .read<BackupBloc>()
                                .add(ExportBackupToUserICloud());
                          },
                        );
                      },
                    ),
                    BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: const Text("CSV로 내보내기"),
                          subtitle: const Text("일기와 감정 강도를 CSV 파일로 내보내기"),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context
                                .read<BackupBloc>()
                                .add(ExportMomentsCsvToUserICloud());
                          },
                        );
                      },
                    ),
                    BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: const Text("CSV+사진으로 내보내기 (ZIP)"),
                          subtitle: const Text("CSV와 사진 원본을 ZIP으로 내보내기"),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context.read<BackupBloc>().add(
                                ExportMomentsCsvWithMediaZipToUserICloud());
                          },
                        );
                      },
                    ),
                    BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: const Text("백업 파일 목록"),
                          subtitle: state.files != null
                              ? Text("백업 파일 목록: ${state.files!.join(", ")}")
                              : const Text("백업 파일 목록이 없습니다."),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<BackupBloc, BackupState>(
                    builder: (context, state) {
                      return state.isLoading
                          ? const Center(child: CommonLoadingIndicator())
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
