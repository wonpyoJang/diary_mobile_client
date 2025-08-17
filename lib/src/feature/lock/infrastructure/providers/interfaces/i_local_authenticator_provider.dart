import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IAuthenticatorProvider {
  Future<Either<LocalAuthFailure, bool>> authenticate();
  Future<Either<LocalAuthFailure, bool>> validatePasscode(
      String input, String? passcode);
}
