import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_lock_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/infrastructure/providers/interfaces/i_local_lock_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILockRepository)
class LockRepository implements ILockRepository {
  final ILocalLockProvider localLockProvider;

  LockRepository({required this.localLockProvider});

  @override
  Future<Either<LocalFailure, bool>> setLockEnabled() async {
    return await localLockProvider.setLockEnabled();
  }

  @override
  Future<Either<LocalFailure, bool>> setLockDisabled() async {
    return await localLockProvider.setLockDisabled();
  }

  @override
  Future<Either<LocalFailure, bool>> getLockEnabled() async {
    return await localLockProvider.getLockEnabled();
  }
}
