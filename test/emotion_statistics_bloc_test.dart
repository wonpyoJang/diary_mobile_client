import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_event.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_state.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_statistics_bloc.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _MockEmotionStatisticsRepository implements IEmotionStatisticsRepository {
  Future<Either<LocalFailure, List<EmotionStats>>> Function()?
      onGetEmotionStats;
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

void main() {
  group('EmotionalStatisticsState', () {
    test('기본 생성자는 initial 상태와 빈 통계여야 함', () {
      const state = EmotionalStatisticsState();
      expect(state.status, EmotionalStatisticsStatus.initial);
      expect(state.emotionStats, isEmpty);
      expect(state.diaryStatistics, equals(DiaryStatistics.empty));
      expect(state.failure, isNull);
    });

    test('copyWith 는 명시한 필드만 변경해야 함', () {
      const original = EmotionalStatisticsState();
      final stats = [_stat(Emotion.happiness, 3)];
      final updated = original.copyWith(
          status: EmotionalStatisticsStatus.ready, emotionStats: stats);
      expect(updated.status, EmotionalStatisticsStatus.ready);
      expect(updated.emotionStats, stats);
      expect(updated.failure, isNull);
    });

    test('동일 값을 가진 상태는 동등해야 함', () {
      const a = EmotionalStatisticsState();
      const b = EmotionalStatisticsState();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('EmotionalStatisticsEvent', () {
    test('FetchEmotionalStatistics 동등성', () {
      expect(const FetchEmotionalStatistics(),
          equals(const FetchEmotionalStatistics()));
    });

    test('FetchDiaryStatistics 는 dailyWindowDays 가 props 에 포함되어야 함', () {
      const a = FetchDiaryStatistics(dailyWindowDays: 30);
      const b = FetchDiaryStatistics(dailyWindowDays: 30);
      const c = FetchDiaryStatistics(dailyWindowDays: 7);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.props, contains(30));
    });

    test('FetchDiaryStatistics 의 기본값은 30', () {
      const event = FetchDiaryStatistics();
      expect(event.dailyWindowDays, 30);
    });
  });

  group('EmotionalStatisticsBloc — FetchEmotionalStatistics', () {
    test('성공 시 ready 상태로 전이하고 emotionStats 를 채움', () async {
      final stats = [
        _stat(Emotion.happiness, 5),
        _stat(Emotion.sadness, 2),
      ];
      final repo = _MockEmotionStatisticsRepository()
        ..onGetEmotionStats = () async => right(stats);
      final bloc = EmotionalStatisticsBloc(repo);

      bloc.add(const FetchEmotionalStatistics());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<EmotionalStatisticsState>(
              (s) => s.status == EmotionalStatisticsStatus.loading),
          predicate<EmotionalStatisticsState>((s) =>
              s.status == EmotionalStatisticsStatus.ready &&
              s.emotionStats.length == 2),
        ]),
      );
      await bloc.close();
    });

    test('실패 시 error 상태와 failure 를 설정', () async {
      const failure = LocalFailure(message: 'DB error');
      final repo = _MockEmotionStatisticsRepository()
        ..onGetEmotionStats = () async => left(failure);
      final bloc = EmotionalStatisticsBloc(repo);

      bloc.add(const FetchEmotionalStatistics());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<EmotionalStatisticsState>((s) =>
            s.status == EmotionalStatisticsStatus.error &&
            s.failure == failure)),
      );
      await bloc.close();
    });
  });

  group('EmotionalStatisticsBloc — FetchDiaryStatistics', () {
    test('성공 시 diaryStatistics 와 emotionStats 가 모두 채워져야 함', () async {
      final stats = [_stat(Emotion.happiness, 4)];
      final diary = DiaryStatistics(
        totalMoments: 10,
        emotionStats: stats,
        dailyMomentCounts: const {},
      );
      final repo = _MockEmotionStatisticsRepository()
        ..onGetDiaryStats = (_) async => right(diary);
      final bloc = EmotionalStatisticsBloc(repo);

      bloc.add(const FetchDiaryStatistics(dailyWindowDays: 30));
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<EmotionalStatisticsState>(
              (s) => s.status == EmotionalStatisticsStatus.loading),
          predicate<EmotionalStatisticsState>((s) =>
              s.status == EmotionalStatisticsStatus.ready &&
              s.diaryStatistics.totalMoments == 10 &&
              s.emotionStats.length == 1),
        ]),
      );
      await bloc.close();
    });

    test('dailyWindowDays 가 repository 로 전달되어야 함', () async {
      int? receivedWindow;
      final repo = _MockEmotionStatisticsRepository()
        ..onGetDiaryStats = (window) async {
          receivedWindow = window;
          return right(DiaryStatistics.empty);
        };
      final bloc = EmotionalStatisticsBloc(repo);

      bloc.add(const FetchDiaryStatistics(dailyWindowDays: 7));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<EmotionalStatisticsState>(
            (s) => s.status == EmotionalStatisticsStatus.ready)),
      );
      expect(receivedWindow, 7);
      await bloc.close();
    });

    test('실패 시 error 상태로 전이', () async {
      const failure = LocalFailure(message: '집계 실패');
      final repo = _MockEmotionStatisticsRepository()
        ..onGetDiaryStats = (_) async => left(failure);
      final bloc = EmotionalStatisticsBloc(repo);

      bloc.add(const FetchDiaryStatistics());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<EmotionalStatisticsState>((s) =>
            s.status == EmotionalStatisticsStatus.error &&
            s.failure == failure)),
      );
      await bloc.close();
    });
  });
}
