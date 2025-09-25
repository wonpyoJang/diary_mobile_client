import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUserInternalProvider {
  Future<Either<LocalFailure, UserDto>> fetchUser();
  Future<Either<LocalFailure, Unit>> upsertUser(UserDto user);
  Future<Either<LocalFailure, Unit>> deleteUser();
}
