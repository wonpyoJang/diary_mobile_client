import 'package:diary_mobile_client/src/feature/signin/domain/failures/signin_failure.dart';
import 'package:diary_mobile_client/src/feature/signin/infrastructure/providers/interfaces/superbase_auth_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/interfaces/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final ISupabaseAuthProvider provider;
  AuthRepository(this.provider);

  @override
  Future<Either<SignInFailure, bool>> signInWithKakao() async {
    return provider.signInWithKakao();
  }

  @override
  Future<Either<SignInFailure, bool>> signInWithApple() async {
    return provider.signInWithApple();
  }

  @override
  Future<Either<SignInFailure, bool>> signOut() async {
    return provider.signOut();
  }

  @override
  Future<Either<SignInFailure, User>> fetchUser() async {
    return provider.fetchUser();
  }
}
