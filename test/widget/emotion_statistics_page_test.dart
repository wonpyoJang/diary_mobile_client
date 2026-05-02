import 'dart:async';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_statistics_bloc.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/presentation/emotion_statistics_page.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _StubRepository implements IEmotionStatisticsRepository {
  Future<Either<LocalFailure, List<EmotionStats>>> Function()? onGetEmotionStats;
  Future<Either<LocalFailure, DiaryStatistics>> Function(int)? onGetDiaryStats;

  @override
  Future<Either<LocalFailure, List<EmotionStats>>> getEmotionStatistics() =>
      onGetEmotionStats?.call() ?? Future.value(right(const <EmotionStats>[]));

  @override
  Future<Either<LocalFailure, DiaryStatistics>> getDiaryStatistics({
    int dailyWindowDays = 30,
  }) =>
      onGetDiaryStats?.call(dailyWindowDays) ??
      Future.value(right(DiaryStatistics.empty));
}

EmotionStats _stat(Emotion e, int count) => EmotionStats(
      emotion: e,
      count: count,
      avgIntensity: 50,
      maxIntensity: 80,
      minIntensity: 20,
      totalIntensity: count * 50.0,
    );

void _registerBloc(_StubRepository repo) {
  if (getIt.isRegistered<EmotionalStatisticsBloc>()) {
    getIt.unregister<EmotionalStatisticsBloc>();
  }
  getIt.registerFactory<EmotionalStatisticsBloc>(
      () => EmotionalStatisticsBloc(repo));
}

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    if (getIt.isRegistered<EmotionalStatisticsBloc>()) {
      getIt.unregister<EmotionalStatisticsBloc>();
    }
  });

  testWidgets('AppBar 에 "감정 통계" 와 뒤로가기 버튼이 있어야 함', (tester) async {
    final repo = _StubRepository()
      ..onGetDiaryStats = (_) async => right(DiaryStatistics.empty);
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pump();

    expect(find.text('감정 통계'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
  });

  testWidgets('초기 로딩 중에는 CircularProgressIndicator 가 보여야 함', (tester) async {
    final completer = Completer<Either<LocalFailure, DiaryStatistics>>();
    final repo = _StubRepository()
      ..onGetDiaryStats = (_) => completer.future;
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // tearDown 전에 future 를 해소해서 pending timer 가 남지 않도록 함.
    completer.complete(right(DiaryStatistics.empty));
    await tester.pumpAndSettle();
  });

  testWidgets('빈 상태에서는 "아직 작성된 일기가 없어요" 안내 텍스트가 보여야 함', (tester) async {
    final repo = _StubRepository()
      ..onGetDiaryStats = (_) async => right(DiaryStatistics.empty);
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.textContaining('아직 작성된 일기가 없어요'), findsOneWidget);
  });

  testWidgets('error 상태에서는 안내 메시지와 failure.message 가 표시되어야 함', (tester) async {
    final repo = _StubRepository()
      ..onGetDiaryStats = (_) async => left(const LocalFailure(message: '에러임'));
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.textContaining('통계를 불러오지 못했습니다'), findsOneWidget);
    expect(find.textContaining('에러임'), findsOneWidget);
  });

  testWidgets('데이터가 있으면 섹션 제목들이 모두 렌더링되어야 함', (tester) async {
    final stats = [
      _stat(Emotion.happiness, 5),
      _stat(Emotion.sadness, 2),
    ];
    final diary = DiaryStatistics(
      totalMoments: 7,
      emotionStats: stats,
      dailyMomentCounts: {DateTime(2026, 5, 1): 1},
    );
    final repo = _StubRepository()..onGetDiaryStats = (_) async => right(diary);
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('감정 분포'), findsOneWidget);
    expect(find.text('가장 많이 느낀 감정 Top 5'), findsOneWidget);
    expect(find.text('최근 30일 작성 빈도'), findsOneWidget);
  });

  testWidgets('빌드 시 FetchDiaryStatistics 이벤트가 자동으로 디스패치되어야 함', (tester) async {
    int callCount = 0;
    int? requestedWindow;
    final repo = _StubRepository()
      ..onGetDiaryStats = (window) async {
        callCount++;
        requestedWindow = window;
        return right(DiaryStatistics.empty);
      };
    _registerBloc(repo);

    await tester.pumpWidget(_wrap(const EmotionStatisticsPage()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(callCount, 1);
    // FetchDiaryStatistics 의 기본 dailyWindowDays 는 30
    expect(requestedWindow, 30);
  });
}
