import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../application/gemma_download_bloc.dart';

class GemmaDownloadPage extends StatelessWidget {
  static const routeName = '/llm/gemma-download';

  const GemmaDownloadPage({super.key});

  static const int _modelSizeBytes = 1500 * 1024 * 1024; // ~1.5 GB

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GemmaDownloadBloc>(
      create: (_) => getIt<GemmaDownloadBloc>(),
      child: const _GemmaDownloadView(),
    );
  }
}

class _GemmaDownloadView extends StatelessWidget {
  const _GemmaDownloadView();

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(size >= 10 || unitIndex == 0 ? 0 : 1)} '
        '${units[unitIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemma 2B 모델'),
        centerTitle: true,
      ),
      body: BlocConsumer<GemmaDownloadBloc, GemmaDownloadState>(
        listener: (context, state) {
          if (state is GemmaDownloadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('다운로드 실패: ${state.message}')),
            );
          }
          if (state is GemmaDownloadCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('다운로드가 취소되었습니다.')),
            );
          }
          if (state is GemmaDownloadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('다운로드가 완료되었습니다.')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ModelInfoCard(
                  modelName: 'Gemma 2B',
                  modelSize: _formatBytes(GemmaDownloadPage._modelSizeBytes),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(child: _buildBody(context, state)),
                ),
                const SizedBox(height: 16),
                _buildActions(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, GemmaDownloadState state) {
    if (state is GemmaDownloadIdle) {
      return const Text(
        '다운로드를 시작하려면 아래 버튼을 눌러주세요.',
        textAlign: TextAlign.center,
      );
    }
    if (state is GemmaDownloadCheckingSpace) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('저장 공간을 확인하는 중...'),
        ],
      );
    }
    if (state is GemmaDownloadInsufficientSpace) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storage, size: 48),
          const SizedBox(height: 12),
          Text(
            '저장 공간이 부족합니다.\n'
            '필요한 공간: ${_formatBytes(state.requiredBytes)}',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    if (state is GemmaDownloadDownloading) {
      final percent = (state.progress * 100).clamp(0, 100).toStringAsFixed(1);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: state.progress),
          const SizedBox(height: 12),
          Text('$percent%'),
        ],
      );
    }
    if (state is GemmaDownloadSuccess) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 48, color: Colors.green),
          SizedBox(height: 12),
          Text('모델이 준비되었습니다.'),
        ],
      );
    }
    if (state is GemmaDownloadFailure) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text('오류: ${state.message}', textAlign: TextAlign.center),
        ],
      );
    }
    if (state is GemmaDownloadCancelled) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel, size: 48),
          SizedBox(height: 12),
          Text('다운로드가 취소되었습니다.'),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildActions(BuildContext context, GemmaDownloadState state) {
    if (state is GemmaDownloadDownloading ||
        state is GemmaDownloadCheckingSpace) {
      return ElevatedButton.icon(
        onPressed: () => context
            .read<GemmaDownloadBloc>()
            .add(const GemmaDownloadCancel()),
        icon: const Icon(Icons.cancel),
        label: const Text('취소'),
      );
    }
    if (state is GemmaDownloadSuccess) {
      return ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('완료'),
      );
    }
    return ElevatedButton.icon(
      onPressed: () => context
          .read<GemmaDownloadBloc>()
          .add(const GemmaDownloadStart()),
      icon: const Icon(Icons.download),
      label: const Text('다운로드 시작'),
    );
  }
}

class _ModelInfoCard extends StatelessWidget {
  const _ModelInfoCard({
    required this.modelName,
    required this.modelSize,
  });

  final String modelName;
  final String modelSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              modelName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text('모델 크기: $modelSize'),
            const SizedBox(height: 4),
            const Text('기기에서 동작하는 온디바이스 LLM 모델입니다.'),
          ],
        ),
      ),
    );
  }
}
