/// 자동 백업 주기를 표현하는 enum.
enum BackupFrequency {
  off,
  daily,
  weekly,
  monthly;

  /// 한국어 표시 라벨.
  String get displayKorean {
    switch (this) {
      case BackupFrequency.off:
        return '끔';
      case BackupFrequency.daily:
        return '매일';
      case BackupFrequency.weekly:
        return '매주';
      case BackupFrequency.monthly:
        return '매월';
    }
  }

  /// 다음 자동 백업까지의 간격.
  ///
  /// - [BackupFrequency.off]: [Duration.zero]
  /// - [BackupFrequency.daily]: 1일
  /// - [BackupFrequency.weekly]: 7일
  /// - [BackupFrequency.monthly]: 30일 (근사값)
  Duration get interval {
    switch (this) {
      case BackupFrequency.off:
        return Duration.zero;
      case BackupFrequency.daily:
        return const Duration(days: 1);
      case BackupFrequency.weekly:
        return const Duration(days: 7);
      case BackupFrequency.monthly:
        return const Duration(days: 30);
    }
  }
}
