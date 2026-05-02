import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/schedule/backup_frequency.dart';
import 'package:equatable/equatable.dart';

/// 자동 백업 스케줄 설정.
///
/// - [frequency]: 백업 주기 (끔/매일/매주/매월)
/// - [preferredHour]: 0–23 시. 사용자가 선호하는 백업 시각 (기본 21시)
/// - [lastSuccessAt]: 마지막 자동 백업 성공 시각. 한 번도 성공한 적 없으면 null
class BackupSchedule extends Equatable {
  final BackupFrequency frequency;
  final int preferredHour;
  final DateTime? lastSuccessAt;

  const BackupSchedule({
    this.frequency = BackupFrequency.off,
    this.preferredHour = 21,
    this.lastSuccessAt,
  });

  /// 현재 시점에 자동 백업을 실행해야 하는지 여부.
  ///
  /// frequency가 [BackupFrequency.off]가 아니고,
  /// (lastSuccessAt이 없거나) lastSuccessAt + interval ≤ now 이면 true.
  bool isDue(DateTime now) {
    if (frequency == BackupFrequency.off) return false;
    final last = lastSuccessAt;
    if (last == null) return true;
    final dueAt = last.add(frequency.interval);
    return !dueAt.isAfter(now);
  }

  /// 다음 예정된 자동 백업 시각.
  ///
  /// - frequency가 off면 null.
  /// - lastSuccessAt이 있으면 lastSuccessAt + interval.
  /// - 없으면 오늘의 preferredHour. 이미 지났으면 내일.
  DateTime? get nextScheduledAt {
    if (frequency == BackupFrequency.off) return null;
    final last = lastSuccessAt;
    if (last != null) {
      return last.add(frequency.interval);
    }
    final now = DateTime.now();
    final candidate = DateTime(now.year, now.month, now.day, preferredHour);
    if (candidate.isAfter(now)) {
      return candidate;
    }
    return candidate.add(const Duration(days: 1));
  }

  BackupSchedule copyWith({
    BackupFrequency? frequency,
    int? preferredHour,
    DateTime? lastSuccessAt,
    bool clearLastSuccess = false,
  }) {
    return BackupSchedule(
      frequency: frequency ?? this.frequency,
      preferredHour: preferredHour ?? this.preferredHour,
      lastSuccessAt:
          clearLastSuccess ? null : (lastSuccessAt ?? this.lastSuccessAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.name,
      'preferredHour': preferredHour,
      'lastSuccessAt': lastSuccessAt?.toIso8601String(),
    };
  }

  static BackupSchedule fromJson(Map<String, dynamic> json) {
    final freqRaw = json['frequency'];
    final frequency = BackupFrequency.values.firstWhere(
      (f) => f.name == freqRaw,
      orElse: () => BackupFrequency.off,
    );
    final hourRaw = json['preferredHour'];
    final preferredHour =
        hourRaw is int ? hourRaw : (hourRaw is num ? hourRaw.toInt() : 21);
    final lastRaw = json['lastSuccessAt'];
    final lastSuccessAt = lastRaw is String ? DateTime.tryParse(lastRaw) : null;
    return BackupSchedule(
      frequency: frequency,
      preferredHour: preferredHour,
      lastSuccessAt: lastSuccessAt,
    );
  }

  @override
  List<Object?> get props => [frequency, preferredHour, lastSuccessAt];
}
