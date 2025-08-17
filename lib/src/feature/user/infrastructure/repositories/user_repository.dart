import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/interfaces/i_superbase_user_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/interfaces/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final ISupabaseUserProvider provider;
  UserRepository(this.provider);

  @override
  Future<Either<UserFailure, User>> fetchUser() async {
    return provider.fetchUser();
  }
}
