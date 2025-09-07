import 'dart:collection';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:fpdart/fpdart.dart';

abstract class IMomentListRepository {
  /// 모든 일기를 날짜별로 그룹화하여 가져옵니다
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getAllMoments();

  /// 특정 날짜의 일기들을 가져옵니다
  Future<Either<LocalFailure, List<Moment>>> getMomentsByDate(DateTime date);

  /// 특정 기간의 일기들을 가져옵니다
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getMomentsByDateRange(DateTime startDate, DateTime endDate);

  /// 특정 id의 일기, 감정 강도, 미디어를 모두 삭제합니다
  Future<Either<LocalFailure, Unit>> deleteMoment(String momentId);
}
