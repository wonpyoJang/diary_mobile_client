import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract class DriftClient {
  Future<Either<LocalFailure, T>> runQuery<T>(
    Future<T> Function(Database db) query, {
    String? description,
  });
}

@singleton
class DriftClientImpl implements DriftClient {
  final Database _database;

  DriftClientImpl(this._database);

  @override
  Future<Either<LocalFailure, T>> runQuery<T>(
    Future<T> Function(Database db) query, {
    String? description,
  }) async {
    final start = DateTime.now();
    try {
      final result = await query(_database);
      final end = DateTime.now();
      // 로깅: 성공
      debugPrint(
          '[DriftClient] SUCCESS: $description, duration:  [32m${end.difference(start).inMilliseconds}ms [0m');
      return right(result);
    } catch (e, stack) {
      final end = DateTime.now();
      // 로깅: 에러
      debugPrint(
          '[DriftClient] ERROR: $description, duration:  [31m${end.difference(start).inMilliseconds}ms [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: 'Drift 쿼리 실행 중 오류 발생\n${e.toString()}',
        code: 'DRIFT_ERROR',
        details: e.toString(),
      ));
    }
  }
}
