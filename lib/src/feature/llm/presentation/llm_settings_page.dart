import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/llm_settings_bloc.dart';
import '../domain/llm_settings.dart';

class LlmSettingsPage extends StatelessWidget {
  const LlmSettingsPage({super.key});

  static const String routeName = '/settings/llm';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LlmSettingsBloc>(
      create: (_) => getIt<LlmSettingsBloc>()..add(const LoadSettings()),
      child: const _LlmSettingsView(),
    );
  }
}

class _LlmSettingsView extends StatelessWidget {
  const _LlmSettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.llmSettingsTitle),
      ),
      body: BlocBuilder<LlmSettingsBloc, LlmSettingsState>(
        builder: (context, state) {
          if (state.isLoading && state.mode == LlmMode.remote &&
              state.backend == null &&
              !state.gemmaDownloaded &&
              !state.appleAvailable) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  text: l10n.llmSettingsTitle,
                ),
                RadioGroup<LlmMode>(
                  groupValue: state.mode,
                  onChanged: (mode) {
                    if (mode != null) {
                      context
                          .read<LlmSettingsBloc>()
                          .add(ChangeMode(mode));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<LlmMode>(
                        title: Text(l10n.llmModeRemoteLabel),
                        value: LlmMode.remote,
                      ),
                      RadioListTile<LlmMode>(
                        title: Text(l10n.llmModeOnDeviceLabel),
                        value: LlmMode.onDevice,
                      ),
                    ],
                  ),
                ),
                if (state.mode == LlmMode.onDevice) ...[
                  const Divider(height: 24),
                  _SectionHeader(text: l10n.llmModeOnDeviceLabel),
                  RadioGroup<OnDeviceBackend>(
                    groupValue: state.backend,
                    onChanged: (backend) {
                      if (backend != null) {
                        context
                            .read<LlmSettingsBloc>()
                            .add(ChangeOnDeviceBackend(backend));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DownloadedModelTile(state: state),
                        _NativeBackendTile(state: state),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.llmPrivacyNotice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _DownloadedModelTile extends StatelessWidget {
  final LlmSettingsState state;

  const _DownloadedModelTile({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSelected = state.backend == OnDeviceBackend.downloadedModel;
    final needsDownload = !state.gemmaDownloaded;
    return RadioListTile<OnDeviceBackend>(
      value: OnDeviceBackend.downloadedModel,
      title: Text(l10n.llmBackendDownloadLabel),
      subtitle: needsDownload ? Text(l10n.llmDownloadRequired) : null,
      secondary: needsDownload
          ? TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/llm/gemma-download');
              },
              child: Text(l10n.llmDownloadButton),
            )
          : (isSelected ? const Icon(Icons.check_circle_outline) : null),
    );
  }
}

class _NativeBackendTile extends StatelessWidget {
  final LlmSettingsState state;

  const _NativeBackendTile({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disabled = !state.appleAvailable;
    return RadioListTile<OnDeviceBackend>(
      value: OnDeviceBackend.platformNative,
      enabled: !disabled,
      title: Text(l10n.llmBackendNativeLabel),
      subtitle: disabled ? Text(l10n.llmBackendNativeUnsupported) : null,
    );
  }
}
