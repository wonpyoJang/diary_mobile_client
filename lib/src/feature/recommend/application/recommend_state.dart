import 'package:diary_mobile_client/src/feature/recommend/domain/entities/recommend_target_result_set.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/entities/recommend_target_status_set.dart';
import 'package:equatable/equatable.dart';

class RecommendState extends Equatable {
  final DateTime? lastRecommendDate;
  final int? recommendCount;
  final RecommendTargetStatusSet? recommendTargetSet;
  final RecommendTargetResultSet recommendResultSet;

  const RecommendState({
    this.lastRecommendDate,
    this.recommendCount,
    this.recommendTargetSet,
    this.recommendResultSet = const RecommendTargetResultSet(
      isRecommendSendingDataToServer: false,
      isRecommendLock: false,
    ),
  });

  @override
  List<Object?> get props => [
        lastRecommendDate,
        recommendCount,
        recommendTargetSet,
        recommendResultSet
      ];

  RecommendState copyWith({
    DateTime? lastRecommendDate,
    int? recommendCount,
    RecommendTargetStatusSet? recommendTargetSet,
    RecommendTargetResultSet? recommendResultSet,
  }) {
    return RecommendState(
      lastRecommendDate: lastRecommendDate ?? this.lastRecommendDate,
      recommendCount: recommendCount ?? this.recommendCount,
      recommendTargetSet: recommendTargetSet ?? this.recommendTargetSet,
      recommendResultSet: recommendResultSet ?? this.recommendResultSet,
    );
  }
}
