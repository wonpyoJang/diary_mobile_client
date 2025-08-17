import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object?> get props => [];
}

class SignInWithKakao extends SignInEvent {}

class SignInWithApple extends SignInEvent {}

class SignInWithEmail extends SignInEvent {
  final String email;
  final String password;
  const SignInWithEmail(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmail extends SignInEvent {
  final String email;
  final String password;
  const SignUpWithEmail(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class SignOut extends SignInEvent {}
