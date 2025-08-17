import 'package:diary_mobile_client/src/feature/signin/domain/failures/signin_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ISupabaseAuthProvider {
  Future<Either<SignInFailure, bool>> signInWithKakao();
  Future<Either<SignInFailure, bool>> signInWithApple();
  Future<Either<SignInFailure, bool>> signOut();
  Future<Either<SignInFailure, User>> fetchUser();
}
