import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/dtos/user_dto.dart';

import 'package:diary_mobile_client/src/feature/user/infrastructure/providers/interfaces/i_superbase_user_external_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: ISupabaseUserExternalProvider)
class SupabaseUserExternalProvider implements ISupabaseUserExternalProvider {
  final SupabaseClient client;
  SupabaseUserExternalProvider(this.client);
  @override
  Future<Either<LocalFailure, UserDto>> getUserFromSupabase() async {
    try {
      final user = client.auth.currentUser;
      return user != null
          ? right(UserDto.fromSupabaseUser(user))
          : left(const LocalFailure(message: 'User not found'));
    } catch (e) {
      return left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> signOut() async {
    try {
      await client.auth.signOut();
      return right(unit);
    } catch (e) {
      return left(LocalFailure(message: e.toString()));
    }
  }
}
