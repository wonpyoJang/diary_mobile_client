import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/interfaces/i_user_internal_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IUserInternalProvider)
class UserInternalProvider implements IUserInternalProvider {
  final DriftClient client;

  UserInternalProvider(this.client);

  @override
  Future<Either<LocalFailure, UserDto>> fetchUser() async {
    final result = await client.runQuery<UserDto>(
      (db) async {
        final user = await db.select(db.userTable).getSingle();
        return UserDto.fromUserTable(user);
      },
      description: 'fetchUser',
    );
    return result;
  }

  @override
  Future<Either<LocalFailure, Unit>> upsertUser(UserDto user) async {
    return await client.runQuery<Unit>((db) async {
      await db.into(db.userTable).insertOnConflictUpdate(
            UserTableCompanion.insert(
              id: user.id,
              username: user.username ?? '',
              profileImageUrl: user.profileImageUrl ?? '',
              email: user.email ?? '',
            ),
          );
      return unit;
    }, description: 'upsertUser');
  }

  @override
  Future<Either<LocalFailure, Unit>> deleteUser() async {
    return await client.runQuery<Unit>((db) async {
      await db.delete(db.userTable).go();
      return unit;
    }, description: 'deleteUser');
  }
}
