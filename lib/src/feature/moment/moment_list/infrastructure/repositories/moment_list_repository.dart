import 'dart:collection';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/domain/interface/i_moment_list_repository.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/infrastructure/interfaces/i_moment_list_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IMomentListRepository)
class MomentListRepository implements IMomentListRepository {
  final IMomentListLocalProvider _localProvider;

  MomentListRepository(this._localProvider);

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
}
