import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends SignInState {}

class AuthLoading extends SignInState {}

class Authenticated extends SignInState {
  final String? userId;
  final String? email;
  const Authenticated({this.userId, this.email});
  @override
  List<Object?> get props => [userId, email];
}

class Unauthenticated extends SignInState {}

class AuthError extends SignInState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
