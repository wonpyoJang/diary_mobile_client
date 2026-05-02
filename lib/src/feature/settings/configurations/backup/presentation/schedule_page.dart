import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/schedule/schedule_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/schedule/schedule_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/schedule/schedule_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_frequency.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  static const routeName = '/backup/schedule';

  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 앱 전역에 BlocProvider로 띄워둔 ScheduleBloc이 있으면 그걸 사용하고,
    // 없으면(예: 단독 테스트) 새 인스턴스를 생성한다.
    try {
      final existing = BlocProvider.of<ScheduleBloc>(context);
      existing.add(const LoadSchedule());
      return BlocProvider<ScheduleBloc>.value(
        value: existing,
        child: const _SchedulePageBody(),
      );
    } catch (_) {
      return BlocProvider<ScheduleBloc>(
        create: (_) => getIt<ScheduleBloc>()..add(const LoadSchedule()),
        child: const _SchedulePageBody(),
      );
    }
  }
}

class _SchedulePageBody extends StatelessWidget {
  const _SchedulePageBody();

  static const _titleStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.4,
    color: Color(0xFF53545B),
  );

  static const _bodyStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.3,
    color: Color(0xFF53545B),
  );

  static const _captionStyle = TextStyle(
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.3,
    color: Color(0xFF959490),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '자동 백업',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.8,
            color: Color(0xFF53545B),
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScheduleBloc, ScheduleState>(
            listenWhen: (prev, curr) =>
                prev.failure != curr.failure && curr.failure != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure!.message),
                  backgroundColor: Colors.red,
                ),
              );
              context
                  .read<ScheduleBloc>()
                  .add(const ClearScheduleMessage());
            },
          ),
          BlocListener<ScheduleBloc, ScheduleState>(
            listenWhen: (prev, curr) =>
                prev.successMessage != curr.successMessage &&
                curr.successMessage != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
              context
                  .read<ScheduleBloc>()
                  .add(const ClearScheduleMessage());
            },
          ),
        ],
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryCard(state: state),
                const SizedBox(height: 16),
                const _SectionLabel(text: '백업 주기'),
                const SizedBox(height: 8),
                _FrequencySelector(state: state),
                const SizedBox(height: 16),
                const _SectionLabel(text: '선호 시각'),
                const SizedBox(height: 8),
                _PreferredHourTile(state: state),
                const SizedBox(height: 16),
                const _BackgroundLimitNotice(),
                const SizedBox(height: 16),
                _LastRunInfo(state: state),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime? dt) {
    if (dt == null) return '없음';
    return DateFormat('yyyy년 MM월 dd일 HH:mm').format(dt.toLocal());
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _SchedulePageBody._titleStyle);
  }
}

class _SummaryCard extends StatelessWidget {
  final ScheduleState state;
  const _SummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final schedule = state.schedule;
    final next = schedule.nextScheduledAt;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: Color(0xFF5361f1)),
              const SizedBox(width: 8),
              Text(
                '현재: ${schedule.frequency.displayKorean}',
                style: _SchedulePageBody._titleStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            schedule.frequency == BackupFrequency.off
                ? '자동 백업이 꺼져 있습니다.'
                : '다음 예정 시각: ${_SchedulePageBody._formatDateTime(next)}',
            style: _SchedulePageBody._bodyStyle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context
                          .read<ScheduleBloc>()
                          .add(const RunBackupNow());
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5361f1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.cloud_upload, size: 18),
              label: Text(
                state.isLoading ? '백업 중…' : '지금 백업하기',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequencySelector extends StatelessWidget {
  final ScheduleState state;
  const _FrequencySelector({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: BackupFrequency.values.map((f) {
          final selected = state.schedule.frequency == f;
          return RadioListTile<BackupFrequency>(
            value: f,
            // ignore: deprecated_member_use
            groupValue: state.schedule.frequency,
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                context
                    .read<ScheduleBloc>()
                    .add(ChangeFrequency(value));
              }
            },
            title: Text(
              f.displayKorean,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFF53545B),
              ),
            ),
            activeColor: const Color(0xFF5361f1),
            controlAffinity: ListTileControlAffinity.trailing,
          );
        }).toList(),
      ),
    );
  }
}

class _PreferredHourTile extends StatelessWidget {
  final ScheduleState state;
  const _PreferredHourTile({required this.state});

  @override
  Widget build(BuildContext context) {
    final hour = state.schedule.preferredHour;
    final timeText = '${hour.toString().padLeft(2, '0')}:00';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: ListTile(
        title: const Text(
          '백업 시각',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            color: Color(0xFF53545B),
          ),
        ),
        subtitle: Text(
          '하루 중 백업을 선호하는 시각 ($timeText)',
          style: _SchedulePageBody._captionStyle,
        ),
        trailing: Text(
          timeText,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            color: Color(0xFF5361f1),
          ),
        ),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: hour, minute: 0),
          );
          if (picked != null && context.mounted) {
            context
                .read<ScheduleBloc>()
                .add(ChangePreferredHour(picked.hour));
          }
        },
      ),
    );
  }
}

class _BackgroundLimitNotice extends StatelessWidget {
  const _BackgroundLimitNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF5C26B)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFFB58015)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '앱을 닫아둔 동안에는 자동 백업이 실행되지 않습니다. '
              '앱을 열 때마다 자동으로 백업 시각을 확인하고, '
              '필요하면 백업을 진행합니다.',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: -0.3,
                color: Color(0xFF6B4A0E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LastRunInfo extends StatelessWidget {
  final ScheduleState state;
  const _LastRunInfo({required this.state});

  @override
  Widget build(BuildContext context) {
    final last = state.schedule.lastSuccessAt;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '마지막 자동 백업: '
        '${_SchedulePageBody._formatDateTime(last)}',
        style: _SchedulePageBody._captionStyle,
      ),
    );
  }
}
