import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client_extensions.dart';
import 'package:diary_mobile_client/src/feature/lock/infrastructure/providers/interfaces/i_local_lock_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILocalLockProvider)
class LocalLockProvider implements ILocalLockProvider {
  final HiveClient hiveClient;

  LocalLockProvider({required this.hiveClient});

  static const String _kLockEnabledKey = 'lock_enabled';

  @override
  Future<Either<LocalFailure, bool>> setLockEnabled() async {
    final result =
        await hiveClient.saveUserSetting<bool>(_kLockEnabledKey, true);
    return result.fold(
      (failure) => left(LocalFailure(message: failure.message)),
      (_) => right(true),
    );
  }

  @override
  Future<Either<LocalFailure, bool>> setLockDisabled() async {
    final result =
        await hiveClient.saveUserSetting<bool>(_kLockEnabledKey, false);
    return result.fold(
      (failure) => left(LocalFailure(message: failure.message)),
      (_) => right(false),
    );
  }

  @override
  Future<Either<LocalFailure, bool>> getLockEnabled() async {
    final result = await hiveClient.getUserSetting<bool>(_kLockEnabledKey);
    return result.fold(
      (failure) => left(LocalFailure(message: failure.message)),
      (isEnabled) => right(isEnabled ?? false),
    );
  }
}
