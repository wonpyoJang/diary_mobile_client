import 'package:equatable/equatable.dart';

abstract class RecommendEvent extends Equatable {
  const RecommendEvent();

  @override
  List<Object?> get props => [];
}

class TriggerRecommend extends RecommendEvent {
  const TriggerRecommend();
}
