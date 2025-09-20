import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class ISupabaseUserExternalProvider {
  Future<Either<UserFailure, UserDto>> fetchUser();
}
