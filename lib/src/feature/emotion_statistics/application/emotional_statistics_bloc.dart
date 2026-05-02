import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_event.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_state.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EmotionalStatisticsBloc
    extends Bloc<EmotionalStatisticsEvent, EmotionalStatisticsState> {
  final IEmotionStatisticsRepository repository;
  EmotionalStatisticsBloc(this.repository)
      : super(const EmotionalStatisticsState()) {
    on<FetchEmotionalStatistics>((event, emit) async {
      emit(state.copyWith(status: EmotionalStatisticsStatus.loading));
      final result = await repository.getEmotionStatistics();
      result.fold(
        (failure) => emit(state.copyWith(
          status: EmotionalStatisticsStatus.error,
          failure: failure,
        )),
        (emotionStats) => emit(state.copyWith(
          status: EmotionalStatisticsStatus.ready,
          emotionStats: emotionStats,
        )),
      );
    });

    on<FetchDiaryStatistics>((event, emit) async {
      emit(state.copyWith(status: EmotionalStatisticsStatus.loading));
      final result = await repository.getDiaryStatistics(
        dailyWindowDays: event.dailyWindowDays,
      );
      result.fold(
        (failure) => emit(state.copyWith(
          status: EmotionalStatisticsStatus.error,
          failure: failure,
        )),
        (stats) => emit(state.copyWith(
          status: EmotionalStatisticsStatus.ready,
          diaryStatistics: stats,
          emotionStats: stats.emotionStats,
        )),
      );
    });
  }
}
