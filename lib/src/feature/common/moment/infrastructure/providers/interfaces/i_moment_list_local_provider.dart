import 'dart:collection';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:fpdart/fpdart.dart';

abstract class IMomentListLocalProvider {
  /// 모든 일기를 날짜별로 그룹화하여 가져옵니다
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getAllMoments();

  /// 특정 날짜의 일기들을 가져옵니다
  Future<Either<LocalFailure, List<Moment>>> getMomentsByDate(DateTime date);

  /// 특정 기간의 일기들을 가져옵니다
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getMomentsByDateRange(DateTime startDate, DateTime endDate);

  /// id로 일기를 삭제합니다
  Future<Either<LocalFailure, Unit>> deleteMoment(String momentId);

  /// 특정 모먼트의 감정 강도 모두 삭제
  Future<Either<LocalFailure, Unit>> deleteMomentEmotionalIntensities(
      String momentId);

  /// 특정 모먼트의 미디어 모두 삭제
  Future<Either<LocalFailure, Unit>> deleteMomentMedias(String momentId);
}
