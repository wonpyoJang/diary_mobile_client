import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class ISupabaseUserExternalProvider {
  Future<Either<LocalFailure, UserDto>> getUserFromSupabase();
  Future<Either<LocalFailure, Unit>> signOut();
}
