import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? username;
  final String? profileImageUrl;
  final String? email;

  const User(this.id, this.username, this.profileImageUrl, this.email);

  @override
  List<Object?> get props => [
        id,
        username,
        profileImageUrl,
        email,
      ];
}
