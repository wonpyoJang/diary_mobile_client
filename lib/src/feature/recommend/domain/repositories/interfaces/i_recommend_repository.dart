import 'package:diary_mobile_client/src/feature/recommend/domain/entities/recommend_target_status_set.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/failures/recommend_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IRecommendRepository {
  Future<Either<RecommendFailure, RecommendTargetStatusSet>>
      getRecommendStatus();
}
