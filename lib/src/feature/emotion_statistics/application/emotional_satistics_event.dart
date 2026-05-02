import 'package:equatable/equatable.dart';

abstract class EmotionalStatisticsEvent extends Equatable {
  const EmotionalStatisticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmotionalStatistics extends EmotionalStatisticsEvent {
  const FetchEmotionalStatistics();
}

class FetchDiaryStatistics extends EmotionalStatisticsEvent {
  final int dailyWindowDays;
  const FetchDiaryStatistics({this.dailyWindowDays = 30});

  @override
  List<Object?> get props => [dailyWindowDays];
}
