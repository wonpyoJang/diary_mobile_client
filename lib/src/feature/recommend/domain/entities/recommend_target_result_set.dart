import 'package:equatable/equatable.dart';

class RecommendTargetResultSet extends Equatable {
  final bool isRecommendSendingDataToServer;
  final bool isRecommendLock;

  const RecommendTargetResultSet(
      {required this.isRecommendSendingDataToServer,
      required this.isRecommendLock});

  @override
  List<Object?> get props => [isRecommendSendingDataToServer, isRecommendLock];

  get isAnythingRecommend => isRecommendSendingDataToServer || isRecommendLock;
}
