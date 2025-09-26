import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {}

class LoadSavedUser extends UserEvent {}

class SignOut extends UserEvent {}
