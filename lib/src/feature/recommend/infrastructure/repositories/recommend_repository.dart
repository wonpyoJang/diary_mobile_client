import 'package:diary_mobile_client/src/feature/data_control/infrastructure/providers/interfaces/i_local_data_control_provider.dart';
import 'package:diary_mobile_client/src/feature/lock/infrastructure/providers/interfaces/i_local_lock_provider.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/entities/recommend_target_status_set.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/failures/recommend_failure.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/repositories/interfaces/i_recommend_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IRecommendRepository)
class RecommendRepository implements IRecommendRepository {
  final ILocalLockProvider localLockProvider;
  final ILocalDataControlProvider localDataControlProvider;

  RecommendRepository(
      {required this.localLockProvider,
      required this.localDataControlProvider});

  @override
  Future<Either<RecommendFailure, RecommendTargetStatusSet>>
      getRecommendStatus() async {
    return await TaskEither<RecommendFailure, bool>(() async {
      final result = await localDataControlProvider.getSendDataToServer();
      return result.mapLeft((f) => RecommendFailure(message: f.message));
    })
        .flatMap((isSending) =>
            TaskEither<RecommendFailure, RecommendTargetStatusSet>(() async {
              final result = await localLockProvider.getLockEnabled();
              return result
                  .map((isLocked) => RecommendTargetStatusSet(
                        isSendingDataToServer: isSending,
                        isLocked: isLocked,
                      ))
                  .mapLeft((f) => RecommendFailure(message: f.message));
            }))
        .run();
  }
}
