import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract class DriftClient {
  Future<Either<LocalFailure, T>> runQuery<T>(
    Future<T> Function(Database db) query, {
    String? description,
  });
}

@Singleton(as: DriftClient)
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
      debugPrint(
          '[DriftClient] SUCCESS: $description, duration:  [32m [32m${end.difference(start).inMilliseconds}ms  [0m');
      return right(result);
    } on DriftWrappedException catch (e, stack) {
      final end = DateTime.now();
      debugPrint(
          '[DriftClient] DRIFT ERROR: $description, duration:  [31m [31m${end.difference(start).inMilliseconds}ms  [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: 'Drift 내부 오류 발생\n [31m${e.toString()} [0m',
        code: 'DRIFT_WRAPPED_ERROR',
        details: e.toString(),
      ));
    } on SqliteException catch (e, stack) {
      final end = DateTime.now();
      debugPrint(
          '[DriftClient] SQLITE ERROR: $description, duration:  [31m [31m${end.difference(start).inMilliseconds}ms  [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: 'SQLite 오류 발생\n [31m${e.toString()} [0m',
        code: 'SQLITE_ERROR',
        details: e.toString(),
      ));
    } on FormatException catch (e, stack) {
      final end = DateTime.now();
      debugPrint(
          '[DriftClient] FORMAT ERROR: $description, duration:  [31m [31m${end.difference(start).inMilliseconds}ms  [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: '데이터 포맷 오류 발생\n [31m${e.toString()} [0m',
        code: 'FORMAT_ERROR',
        details: e.toString(),
      ));
    } on TypeError catch (e, stack) {
      final end = DateTime.now();
      debugPrint(
          '[DriftClient] TYPE ERROR: $description, duration:  [31m [31m${end.difference(start).inMilliseconds}ms  [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: '타입 변환 오류 발생\n [31m${e.toString()} [0m',
        code: 'TYPE_ERROR',
        details: e.toString(),
      ));
    } catch (e, stack) {
      final end = DateTime.now();
      debugPrint(
          '[DriftClient] UNKNOWN ERROR: $description, duration:  [31m [31m [31m${end.difference(start).inMilliseconds}ms  [0m, error: $e');
      debugPrint(stack.toString());
      return left(LocalFailure(
        message: 'Drift 쿼리 실행 중 오류 발생\n [31m${e.toString()} [0m',
        code: 'UNKNOWN_ERROR',
        details: e.toString(),
      ));
    }
  }
}
