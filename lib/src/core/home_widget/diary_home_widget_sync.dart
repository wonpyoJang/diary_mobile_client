import 'dart:convert';
import 'dart:io';

import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';

import 'diary_home_widget_config.dart';

/// Drift 데이터를 home_widget 저장소에 반영하고 네이티브 위젯을 갱신한다.
@lazySingleton
class DiaryHomeWidgetSync {
  DiaryHomeWidgetSync(this._driftClient);

  final DriftClient _driftClient;

  Future<void> initPlugin() async {
    if (kIsWeb) return;
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(DiaryHomeWidgetConfig.iOSAppGroupId);
    }
  }

  /// 최신 통계를 저장하고 위젯을 reload 한다. 실패해도 앱 동작에는 영향 없음.
  Future<void> refresh() async {
    if (kIsWeb) return;

    final snapshot = await _loadSnapshot();
    if (snapshot == null) return;

    try {
      await HomeWidget.saveWidgetData<String>(
        DiaryHomeWidgetConfig.dataKeyStreak,
        '${snapshot.streak}',
      );
      await HomeWidget.saveWidgetData<String>(
        DiaryHomeWidgetConfig.dataKeyToday,
        snapshot.todaySummary,
      );
      await HomeWidget.saveWidgetData<String>(
        DiaryHomeWidgetConfig.dataKeyWeek,
        snapshot.weekJson,
      );

      await HomeWidget.updateWidget(
        qualifiedAndroidName:
            'com.cassette.diary_mobile_client.DiaryQuickEmotionWidget',
      );
      await HomeWidget.updateWidget(
        qualifiedAndroidName:
            'com.cassette.diary_mobile_client.DiaryStatsWidget',
      );

      if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: 'DiaryQuickEmotionWidget');
        await HomeWidget.updateWidget(iOSName: 'DiaryStatsWidget');
      }
    } catch (e, st) {
      debugPrint('[DiaryHomeWidgetSync] refresh failed: $e\n$st');
    }
  }

  Future<_WidgetSnapshot?> _loadSnapshot() async {
    final result = await _driftClient.runQuery<_WidgetSnapshot?>((db) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final streak = await _writingStreak(db, today);

      final tomorrow = today.add(const Duration(days: 1));
      final todayMoments = await (db.select(db.momentTable)
            ..where((tbl) => tbl.date.isBiggerOrEqualValue(today))
            ..where((tbl) => tbl.date.isSmallerThanValue(tomorrow)))
          .get();

      final todayIds = todayMoments.map((m) => m.id).toSet();
      final todayLabel = await _topEmotionLabelsForMoments(db, todayIds, 3);

      final weekStart = today.subtract(const Duration(days: 6));
      final weekMoments = await (db.select(db.momentTable)
            ..where((tbl) => tbl.date.isBiggerOrEqualValue(weekStart)))
          .get();
      final weekIds = weekMoments.map((m) => m.id).toSet();
      final weekDist = await _emotionCountsForMoments(db, weekIds);

      final weekJson = jsonEncode(
        weekDist.entries
            .map((e) => {'emotion': e.key.name, 'count': e.value})
            .toList(),
      );

      return _WidgetSnapshot(
        streak: streak,
        todaySummary: todayLabel,
        weekJson: weekJson,
      );
    }, description: 'DiaryHomeWidgetSync snapshot');

    return result.fold((_) => null, (v) => v);
  }

  Future<int> _writingStreak(Database db, DateTime today) async {
    var streak = 0;
    var day = today;
    while (true) {
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));
      final rows = await (db.select(db.momentTable)
            ..where((tbl) => tbl.date.isBiggerOrEqualValue(start))
            ..where((tbl) => tbl.date.isSmallerThanValue(end)))
          .get();
      if (rows.isEmpty) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<String> _topEmotionLabelsForMoments(
    Database db,
    Set<String> momentIds,
    int limit,
  ) async {
    if (momentIds.isEmpty) return '—';

    final intensities = await db.select(db.emotionalIntensityTable).get();
    final counts = <Emotion, int>{};
    for (final row in intensities) {
      if (!momentIds.contains(row.momentId)) continue;
      counts[row.emotion] = (counts[row.emotion] ?? 0) + 1;
    }
    if (counts.isEmpty) return '—';

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(limit)
        .map((e) => e.key.enName)
        .join(', ');
  }

  Future<Map<Emotion, int>> _emotionCountsForMoments(
    Database db,
    Set<String> momentIds,
  ) async {
    final result = <Emotion, int>{};
    if (momentIds.isEmpty) return result;

    final intensities = await db.select(db.emotionalIntensityTable).get();
    for (final row in intensities) {
      if (!momentIds.contains(row.momentId)) continue;
      result[row.emotion] = (result[row.emotion] ?? 0) + 1;
    }
    return result;
  }
}

class _WidgetSnapshot {
  _WidgetSnapshot({
    required this.streak,
    required this.todaySummary,
    required this.weekJson,
  });

  final int streak;
  final String todaySummary;
  final String weekJson;
}
