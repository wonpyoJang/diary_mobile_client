import 'package:diary_mobile_client/src/feature/user/domain/failures/user_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserState extends Equatable {
  final User? user;
  final UserFailure? failure;
  const UserState({this.user, this.failure});
  @override
  List<Object?> get props => [user, failure];

  factory UserState.initial() => const UserState();

  copyWith({User? user, UserFailure? failure}) =>
      UserState(user: user ?? this.user, failure: failure ?? this.failure);
}
