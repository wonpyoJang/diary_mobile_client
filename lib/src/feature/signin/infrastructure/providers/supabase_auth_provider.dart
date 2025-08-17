import 'package:diary_mobile_client/src/feature/signin/domain/failures/signin_failure.dart';
import 'package:diary_mobile_client/src/feature/signin/infrastructure/providers/interfaces/superbase_auth_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: ISupabaseAuthProvider)
class SupabaseAuthProvider implements ISupabaseAuthProvider {
  final SupabaseClient client;
  SupabaseAuthProvider(this.client);

  @override
  Future<Either<SignInFailure, bool>> signInWithKakao() async {
    try {
      final result = await client.auth.signInWithOAuth(OAuthProvider.kakao,
          redirectTo: 'cassette-diary://login-callback',
          authScreenLaunchMode: LaunchMode.externalApplication);
      return right(result);
    } catch (e) {
      return left(SignInFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<SignInFailure, bool>> signInWithApple() async {
    try {
      final result = await client.auth.signInWithOAuth(OAuthProvider.apple,
          redirectTo: 'cassette-diary://login-callback');
      return right(result);
    } catch (e) {
      return left(SignInFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<SignInFailure, bool>> signOut() async {
    try {
      await client.auth.signOut();
      return right(true);
    } catch (e) {
      return left(SignInFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<SignInFailure, User>> fetchUser() async {
    try {
      final user = client.auth.currentUser;
      return user != null
          ? right(user)
          : left(SignInFailure(message: 'User not found'));
    } catch (e) {
      return left(SignInFailure(message: e.toString()));
    }
  }
}
