import 'dart:collection';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/domain/interface/i_moment_list_repository.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/providers/interfaces/i_moment_list_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';

@Injectable(as: IMomentListRepository)
class MomentListRepository implements IMomentListRepository {
  final IMomentListLocalProvider _localProvider;
  final DriftClient _driftClient;
  // final DriftClient _driftClient; // 사용하지 않으므로 제거

  MomentListRepository(this._localProvider, this._driftClient);

  @override
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getAllMoments() async {
    return await _localProvider.getAllMoments();
  }

  @override
  Future<Either<LocalFailure, List<Moment>>> getMomentsByDate(
      DateTime date) async {
    return await _localProvider.getMomentsByDate(date);
  }

  @override
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getMomentsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _localProvider.getMomentsByDateRange(startDate, endDate);
  }

  @override
  Future<Either<LocalFailure, Unit>> deleteMoment(String momentId) async {
    return await _driftClient.runQuery<Unit>((db) async {
      final emotionResult =
          await _localProvider.deleteMomentEmotionalIntensities(momentId);
      if (emotionResult.isLeft()) {
        throw emotionResult.getLeft().toNullable()!;
      }
      final mediaResult = await _localProvider.deleteMomentMedias(momentId);
      if (mediaResult.isLeft()) {
        throw mediaResult.getLeft().toNullable()!;
      }
      final momentResult = await _localProvider.deleteMoment(momentId);
      if (momentResult.isLeft()) {
        throw momentResult.getLeft().toNullable()!;
      }
      return unit;
    }, description: 'deleteMoment (transaction)');
  }
}
