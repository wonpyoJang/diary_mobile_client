import 'dart:io';

import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/destination_action_cubit.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/widgets/backup_destination_card.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/widgets/backup_files_list.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/widgets/backup_status_header.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/presentation/widgets/section_header.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 백업 설정 페이지.
///
/// 섹션 기반 카드 UI:
///   1) 상단 백업 상태 헤더 + "지금 백업하기" 버튼
///   2) "백업 보낼 곳" 섹션 — 3개의 destination 카드
///   3) "익스포트 형식" 섹션 — CSV, CSV + 사진 ZIP
///   4) "자동 백업" 섹션 — 스케줄 페이지로 이동
///   5) "복원" 섹션 — 복원 페이지로 이동
///   6) "iCloud 백업 파일" 섹션 — iCloud 파일 목록
///
/// `/backup/restore`, `/backup/schedule` 라우트는 다른 worktree에서 작성 중
/// 이라 import할 수 없다. Phase 2 통합 단계에서 [MaterialApp.routes] 또는
/// [Navigator.onGenerateRoute]에 등록될 예정이다.
class BackupPage extends StatelessWidget {
  static const routeName = '/backup';

  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BackupBloc>(
          create: (_) => getIt<BackupBloc>()..add(FetchICloudFiles()),
        ),
        BlocProvider<DestinationActionCubit>(
          create: (_) => getIt<DestinationActionCubit>(),
        ),
      ],
      child: const _BackupPageView(),
    );
  }
}

class _BackupPageView extends StatelessWidget {
  const _BackupPageView();

  /// 현재 플랫폼에 어울리는 default destination을 결정한다.
  ///
  /// - iOS: iCloud
  /// - Android(또는 그 외): 로컬 폴더
  BackupDestinationKind _defaultDestinationKind() {
    if (Platform.isIOS) return BackupDestinationKind.icloud;
    return BackupDestinationKind.localFolder;
  }

  void _dispatchToDestination(
    BuildContext context,
    BackupDestinationKind kind,
  ) {
    if (kind == BackupDestinationKind.icloud) {
      // iCloud는 기존 BackupBloc 흐름(=네이티브 채널)을 그대로 사용.
      context.read<BackupBloc>().add(UploadBackup());
    } else {
      // 로컬 폴더 / 공유 시트는 새로 추가된 destination 추상화로 처리.
      context.read<DestinationActionCubit>().sendToDestination(kind);
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<BackupBloc>().add(FetchICloudFiles());
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  void _showSnackBar(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final defaultKind = _defaultDestinationKind();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          '백업 설정',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF53545B),
            letterSpacing: -0.4,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF53545B)),
      ),
      body: MultiBlocListener(
        listeners: [
          // BackupBloc: 실패 SnackBar (다시 시도 액션 포함)
          BlocListener<BackupBloc, BackupState>(
            listenWhen: (prev, curr) =>
                prev.failure != curr.failure && curr.failure != null,
            listener: (context, state) {
              _showSnackBar(
                context,
                message: state.failure!.message,
                backgroundColor: const Color(0xFFEC7C61),
                action: SnackBarAction(
                  label: '다시 시도',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<BackupBloc>().add(UploadBackup());
                  },
                ),
              );
              context.read<BackupBloc>().add(ClearBackupMessage());
            },
          ),
          // BackupBloc: 성공 SnackBar
          BlocListener<BackupBloc, BackupState>(
            listenWhen: (prev, curr) =>
                prev.successMessage != curr.successMessage &&
                curr.successMessage != null,
            listener: (context, state) {
              _showSnackBar(context, message: state.successMessage!);
              context.read<BackupBloc>().add(ClearBackupMessage());
            },
          ),
          // DestinationActionCubit: 실패 SnackBar (다시 시도 액션 포함)
          BlocListener<DestinationActionCubit, DestinationActionState>(
            listenWhen: (prev, curr) =>
                prev.failure != curr.failure && curr.failure != null,
            listener: (context, state) {
              _showSnackBar(
                context,
                message: state.failure!.message,
                backgroundColor: const Color(0xFFEC7C61),
                action: SnackBarAction(
                  label: '다시 시도',
                  textColor: Colors.white,
                  onPressed: () {
                    final kind = state.lastSuccessKind ?? defaultKind;
                    _dispatchToDestination(context, kind);
                  },
                ),
              );
              context.read<DestinationActionCubit>().clearMessages();
            },
          ),
          // DestinationActionCubit: 성공 SnackBar
          BlocListener<DestinationActionCubit, DestinationActionState>(
            listenWhen: (prev, curr) =>
                prev.successMessage != curr.successMessage &&
                curr.successMessage != null,
            listener: (context, state) {
              _showSnackBar(context, message: state.successMessage!);
              context.read<DestinationActionCubit>().clearMessages();
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              // 1) 상단 헤더
              BlocBuilder<BackupBloc, BackupState>(
                builder: (context, backupState) {
                  return BlocBuilder<DestinationActionCubit,
                      DestinationActionState>(
                    builder: (context, actionState) {
                      final isWorking =
                          backupState.isLoading || actionState.isWorking;
                      return BackupStatusHeader(
                        lastBackupDate: backupState.lastBackupDate,
                        isLoading: isWorking,
                        onQuickBackup: () =>
                            _dispatchToDestination(context, defaultKind),
                      );
                    },
                  );
                },
              ),

              // 2) 백업 보낼 곳
              const SectionHeader('백업 보낼 곳'),
              if (Platform.isIOS)
                BlocBuilder<BackupBloc, BackupState>(
                  builder: (context, state) {
                    return BackupDestinationCard(
                      kind: BackupDestinationKind.icloud,
                      lastBackupAt: state.lastBackupDate,
                      isLoading: state.isLoading,
                      onTap: () => _dispatchToDestination(
                        context,
                        BackupDestinationKind.icloud,
                      ),
                    );
                  },
                ),
              BlocBuilder<DestinationActionCubit, DestinationActionState>(
                builder: (context, state) {
                  return BackupDestinationCard(
                    kind: BackupDestinationKind.localFolder,
                    isLoading: state.isWorking,
                    onTap: () => _dispatchToDestination(
                      context,
                      BackupDestinationKind.localFolder,
                    ),
                  );
                },
              ),
              BlocBuilder<DestinationActionCubit, DestinationActionState>(
                builder: (context, state) {
                  return BackupDestinationCard(
                    kind: BackupDestinationKind.shareSheet,
                    isLoading: state.isWorking,
                    onTap: () => _dispatchToDestination(
                      context,
                      BackupDestinationKind.shareSheet,
                    ),
                  );
                },
              ),

              // 3) 익스포트 형식
              const SectionHeader('익스포트 형식'),
              _buildSimpleCard(
                context,
                title: 'CSV로 내보내기',
                subtitle: '일기와 감정 강도를 CSV 파일로 내보내기',
                icon: Icons.description_outlined,
                onTap: () {
                  context
                      .read<BackupBloc>()
                      .add(ExportMomentsCsvToUserICloud());
                },
              ),
              _buildSimpleCard(
                context,
                title: 'CSV + 사진 ZIP',
                subtitle: 'CSV와 사진 원본을 ZIP으로 묶어 내보내기',
                icon: Icons.archive_outlined,
                onTap: () {
                  context
                      .read<BackupBloc>()
                      .add(ExportMomentsCsvWithMediaZipToUserICloud());
                },
              ),

              // 4) 자동 백업
              const SectionHeader('자동 백업'),
              _buildSimpleCard(
                context,
                title: '자동 백업 설정',
                subtitle: '주기적으로 자동 백업을 실행해요',
                icon: Icons.schedule_outlined,
                onTap: () {
                  // NOTE: SchedulePage는 다른 worktree에서 작성 중이라
                  // 직접 import할 수 없습니다. Phase 2 통합 단계에서
                  // `/backup/schedule` 라우트가 등록되면 자동 연결됩니다.
                  Navigator.of(context).pushNamed('/backup/schedule');
                },
              ),

              // 5) 복원
              const SectionHeader('복원'),
              _buildSimpleCard(
                context,
                title: '백업에서 복원하기',
                subtitle: '저장된 백업 파일로 데이터를 되돌려요',
                icon: Icons.restore_outlined,
                onTap: () {
                  // NOTE: RestorePage 역시 다른 worktree에서 작성 중입니다.
                  // Phase 2에서 `/backup/restore` 라우트 등록 필요.
                  Navigator.of(context).pushNamed('/backup/restore');
                },
              ),

              // 6) iCloud 파일 목록
              const SectionHeader('iCloud 백업 파일'),
              BlocBuilder<BackupBloc, BackupState>(
                builder: (context, state) {
                  return BackupFilesList(files: state.files);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF53545B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1B1F),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7C7E84),
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF93B1F3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
