import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ISupabaseUserProvider {
  Future<Either<UserFailure, User>> fetchUser();
}
