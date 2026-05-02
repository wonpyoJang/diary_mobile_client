import 'package:diary_mobile_client/src/feature/common/loading_indicator.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/restore/restore_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/restore/restore_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/restore/restore_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_format.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_preview.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// 백업 복원 페이지.
///
/// 3단계 흐름을 명시적으로 보여주기 위해 위쪽에 단계 인디케이터를 둔다.
/// - 1단계: 파일 선택
/// - 2단계: 미리보기 + 모드 선택
/// - 3단계: 확인 다이얼로그(별도 라우트가 아니라 모달)
class RestorePage extends StatelessWidget {
  static const routeName = '/backup/restore';

  const RestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RestoreBloc>(),
      child: const _RestoreView(),
    );
  }
}

class _RestoreView extends StatelessWidget {
  const _RestoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        title: const Text(
          '백업 복원',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.8,
            color: Color(0xFF53545B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<RestoreBloc, RestoreState>(
        listener: (context, state) {
          if (state.failure != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.failure!.message),
                  backgroundColor: const Color(0xFFB00020),
                ),
              );
            context.read<RestoreBloc>().add(const ClearRestoreMessage());
          }
          if (state.phase == RestorePhase.done &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.successMessage!)),
              );
            if (state.requiresRestart) {
              _showRestartDialog(context);
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _StepIndicator(currentStep: _stepFor(state)),
                    Expanded(
                      child: _buildBody(context, state),
                    ),
                  ],
                ),
              ),
              if (state.isLoading) const Center(child: CommonLoadingIndicator()),
            ],
          );
        },
      ),
    );
  }

  /// 화면에 보여줄 1/3, 2/3, 3/3 단계 추출.
  /// 3단계는 다이얼로그가 떠 있는 동안의 일시적 상태라 applying/done에 매핑.
  int _stepFor(RestoreState state) {
    if (state.phase == RestorePhase.applying ||
        state.phase == RestorePhase.done) {
      return 3;
    }
    if (state.preview != null) return 2;
    return 1;
  }

  Widget _buildBody(BuildContext context, RestoreState state) {
    if (state.preview == null) {
      return _PickFileStep(
        onPick: () => context.read<RestoreBloc>().add(const PickRestoreFile()),
      );
    }
    return _PreviewAndModeStep(
      preview: state.preview!,
      selectedMode: state.selectedMode,
      onSelectMode: (mode) =>
          context.read<RestoreBloc>().add(SelectRestoreMode(mode)),
      onBack: () => context.read<RestoreBloc>().add(const ResetRestore()),
      onProceed: () => _confirmAndRun(context, state),
    );
  }

  Future<void> _confirmAndRun(
    BuildContext context,
    RestoreState state,
  ) async {
    final preview = state.preview;
    final mode = state.selectedMode;
    if (preview == null || mode == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(mode: mode, preview: preview),
    );
    if (ok == true && context.mounted) {
      context.read<RestoreBloc>().add(const ConfirmRestore());
    }
  }

  Future<void> _showRestartDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('앱을 재시작해주세요'),
        content: const Text(
          'SQLite 백업은 앱이 사용 중인 데이터베이스 파일을 직접 교체하므로, '
          '변경 사항을 적용하려면 앱을 종료한 뒤 다시 실행해야 합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('나중에'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('지금 종료'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 단계 인디케이터
// =============================================================================

class _StepIndicator extends StatelessWidget {
  final int currentStep; // 1..3
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _stepDot(1, '파일 선택'),
          _connector(currentStep >= 2),
          _stepDot(2, '검토'),
          _connector(currentStep >= 3),
          _stepDot(3, '적용'),
        ],
      ),
    );
  }

  Widget _stepDot(int step, String label) {
    final active = currentStep >= step;
    final color = active ? const Color(0xFF4169E1) : const Color(0xFFCFCFD3);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '$step',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF53545B) : const Color(0xFF9A9AA0),
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _connector(bool active) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: active ? const Color(0xFF4169E1) : const Color(0xFFE5E5E8),
    );
  }
}

// =============================================================================
// 1단계: 파일 선택
// =============================================================================

class _PickFileStep extends StatelessWidget {
  final VoidCallback onPick;
  const _PickFileStep({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onPick,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E8)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.folder_open,
                      size: 48, color: Color(0xFF4169E1)),
                  SizedBox(height: 12),
                  Text(
                    '백업 파일 선택하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF53545B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '저장된 백업을 골라 복원할 수 있습니다',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      color: Color(0xFF9A9AA0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '지원 형식: .sqlite, .zip, .csv\n\n'
              '· SQLite/ZIP(SQLite): 덮어쓰기만 가능합니다 (앱 재시작 필요).\n'
              '· CSV / ZIP(CSV+사진): 덮어쓰기와 병합 모두 가능합니다.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                height: 1.6,
                color: Color(0xFF53545B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 2단계: 미리보기 + 모드 선택
// =============================================================================

class _PreviewAndModeStep extends StatelessWidget {
  final RestorePreview preview;
  final RestoreMode? selectedMode;
  final ValueChanged<RestoreMode> onSelectMode;
  final VoidCallback onBack;
  final VoidCallback onProceed;

  const _PreviewAndModeStep({
    required this.preview,
    required this.selectedMode,
    required this.onSelectMode,
    required this.onBack,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final canProceed = selectedMode != null;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PreviewCard(preview: preview),
              const SizedBox(height: 16),
              const Text(
                '복원 모드',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF53545B),
                ),
              ),
              const SizedBox(height: 8),
              _ModeOption(
                mode: RestoreMode.overwrite,
                title: '덮어쓰기',
                subtitle: '현재 데이터를 모두 대체합니다',
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFD93B3B),
                disabledReason: preview.supportedModes
                        .contains(RestoreMode.overwrite)
                    ? null
                    : '이 형식에서는 사용할 수 없습니다',
                selected: selectedMode == RestoreMode.overwrite,
                onSelect: onSelectMode,
              ),
              const SizedBox(height: 8),
              _ModeOption(
                mode: RestoreMode.merge,
                title: '병합',
                subtitle: '기존 데이터에 합칩니다 — 같은 일기는 최신본 유지\n'
                    '신규 ${preview.newCount}개 / 충돌 ${preview.conflictCount}개(최신 유지)',
                icon: Icons.merge_type,
                iconColor: const Color(0xFF4169E1),
                disabledReason:
                    preview.supportedModes.contains(RestoreMode.merge)
                        ? null
                        : 'SQLite 형식은 병합을 지원하지 않습니다.\n(두 DB를 동시에 다루는 비용을 피하기 위함)',
                selected: selectedMode == RestoreMode.merge,
                onSelect: onSelectMode,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('뒤로'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: canProceed ? onProceed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4169E1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('계속'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final RestorePreview preview;
  const _PreviewCard({required this.preview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insert_drive_file_outlined,
                  color: Color(0xFF4169E1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  preview.fileName,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF53545B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row('형식', _formatLabel(preview.format)),
          _row('파일 크기', _humanSize(preview.fileSizeBytes)),
          if (preview.momentCount >= 0)
            _row('모먼트 수', '${preview.momentCount}건'),
          if (preview.mediaCount > 0)
            _row('미디어 파일 수', '${preview.mediaCount}개'),
          if (preview.backupCreatedAt != null)
            _row(
              '백업 시각',
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(preview.backupCreatedAt!.toLocal()),
            ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              child: Text(
                k,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  color: Color(0xFF9A9AA0),
                ),
              ),
            ),
            Expanded(
              child: Text(
                v,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  color: Color(0xFF53545B),
                ),
              ),
            ),
          ],
        ),
      );

  String _formatLabel(RestoreFormat f) {
    switch (f) {
      case RestoreFormat.sqlite:
        return 'SQLite (.sqlite)';
      case RestoreFormat.sqliteZip:
        return 'ZIP — SQLite';
      case RestoreFormat.csv:
        return 'CSV (.csv)';
      case RestoreFormat.csvMediaZip:
        return 'ZIP — CSV + 미디어';
      case RestoreFormat.unknown:
        return '알 수 없음';
    }
  }

  String _humanSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _ModeOption extends StatelessWidget {
  final RestoreMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? disabledReason;
  final bool selected;
  final ValueChanged<RestoreMode> onSelect;

  const _ModeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.disabledReason,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = disabledReason != null;
    final borderColor = selected
        ? const Color(0xFF4169E1)
        : (disabled ? const Color(0xFFE5E5E8) : const Color(0xFFE5E5E8));
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: GestureDetector(
        onTap: disabled ? null : () => onSelect(mode),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 직접 그린 라디오 인디케이터 — Material의 Radio는 Flutter 3.32+
              // 에서 RadioGroup 사용을 강제하지만, 우리 카드 자체가 토글이라
              // 시각적 점만 그려주면 충분.
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2, right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF4169E1)
                        : const Color(0xFFCFCFD3),
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4169E1),
                          ),
                        ),
                      )
                    : null,
              ),
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF53545B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disabledReason ?? subtitle,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: Color(0xFF53545B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3단계: 확인 다이얼로그
// =============================================================================

class _ConfirmDialog extends StatefulWidget {
  final RestoreMode mode;
  final RestorePreview preview;
  const _ConfirmDialog({required this.mode, required this.preview});

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _ack = false;

  @override
  Widget build(BuildContext context) {
    final isOverwrite = widget.mode == RestoreMode.overwrite;
    return AlertDialog(
      title: Text(isOverwrite ? '정말로 덮어쓸까요?' : '병합을 진행할까요?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOverwrite)
            const Text(
              '현재 데이터가 영구히 삭제되고 백업의 내용으로 대체됩니다. '
              '이 동작은 되돌릴 수 없습니다.',
              style: TextStyle(color: Color(0xFFB00020)),
            )
          else
            Text(
              '백업의 ${widget.preview.momentCount}건 중 '
              '신규 ${widget.preview.newCount}건은 추가되고, '
              '충돌 ${widget.preview.conflictCount}건은 modifiedAt이 최신인 쪽이 유지됩니다.',
            ),
          if (isOverwrite) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _ack,
                  onChanged: (v) => setState(() => _ack = v ?? false),
                ),
                const Expanded(
                  child: Text('위험성을 이해했고, 진행합니다'),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: (isOverwrite && !_ack)
              ? null
              : () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isOverwrite ? const Color(0xFFB00020) : const Color(0xFF4169E1),
            foregroundColor: Colors.white,
          ),
          child: Text(isOverwrite ? '덮어쓰기' : '병합'),
        ),
      ],
    );
  }
}
