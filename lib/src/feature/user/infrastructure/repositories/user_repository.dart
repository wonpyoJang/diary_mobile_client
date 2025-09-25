import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/user/domain/entity/user.dart';
import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/interfaces/i_superbase_user_external_provider.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/interfaces/i_user_internal_provider.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/interfaces/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final ISupabaseUserExternalProvider externalProvider;
  final IUserInternalProvider internalProvider;
  UserRepository(this.externalProvider, this.internalProvider);

  @override
  Future<Either<UserFailure, User>> getAndStoreUser() async {
    return (await TaskEither<LocalFailure, UserDto>(
                () => externalProvider.getUserFromSupabase())
            .flatMap((user) => TaskEither<LocalFailure, UserDto>(() async {
                  // 성공 시 로컬 DB upsert (실패해도 원격 fetch 성공은 그대로 반환)
                  await internalProvider.upsertUser(user);
                  return right(user);
                }))
            .map((user) => user.toDomain())
            .run())
        .mapLeft((failure) => UserFailure(message: failure.message));
  }

  @override
  Future<Either<UserFailure, User>> getUserFromLocal() async {
    return (await TaskEither<LocalFailure, UserDto>(
                () => internalProvider.fetchUser())
            .map((user) => user.toDomain())
            .run())
        .mapLeft((failure) => UserFailure(message: failure.message));
  }

  @override
  Future<Either<UserFailure, Unit>> deleteUser() async {
    return (await TaskEither<LocalFailure, Unit>(
            () => internalProvider.deleteUser()).run())
        .mapLeft((failure) => UserFailure(message: failure.message));
  }

  @override
  Future<Either<UserFailure, Unit>> signOut() async {
    return (await TaskEither<LocalFailure, Unit>(
            () => externalProvider.signOut()).run())
        .mapLeft((failure) => UserFailure(message: failure.message));
  }
}
