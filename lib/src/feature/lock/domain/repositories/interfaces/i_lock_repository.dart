import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class ILockRepository {
  Future<Either<LocalFailure, bool>> setLockEnabled();
  Future<Either<LocalFailure, bool>> setLockDisabled();
  Future<Either<LocalFailure, bool>> getLockEnabled();
}
