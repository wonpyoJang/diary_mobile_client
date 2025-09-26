import 'package:diary_mobile_client/src/feature/user/domain/entity/user.dart';
import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUserRepository {
  Future<Either<UserFailure, User>> getAndStoreUser();
  Future<Either<UserFailure, User>> getUserFromLocal();
  Future<Either<UserFailure, Unit>> deleteUser();
  Future<Either<UserFailure, Unit>> signOut();
}
