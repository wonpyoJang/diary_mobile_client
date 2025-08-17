import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/infrastructure/providers/interfaces/i_local_authenticator_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthenticatorRepository)
class LocalAuthenticatorRepository implements IAuthenticatorRepository {
  final IAuthenticatorProvider authenticatorProvider;

  LocalAuthenticatorRepository({
    required this.authenticatorProvider,
  });

  @override
  Future<Either<LocalAuthFailure, bool>> authenticate() async {
    return await authenticatorProvider.authenticate();
  }

  @override
  Future<Either<LocalAuthFailure, bool>> validatePasscode(
      String input, String? passcode) async {
    return await authenticatorProvider.validatePasscode(input, passcode);
  }
}
