import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/user/domain/entity/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final class UserDto {
  final String id;
  final String? username;
  final String? profileImageUrl;
  final String? email;

  UserDto({
    required this.id,
    this.username,
    this.profileImageUrl,
    this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'email': email,
    };
  }

  User toDomain() {
    return User(id, username, profileImageUrl, email);
  }

  factory UserDto.fromDomain(User domain) {
    return UserDto(
      id: domain.id,
      username: domain.username,
      profileImageUrl: domain.profileImageUrl,
      email: domain.email,
    );
  }

  factory UserDto.fromSupabaseUser(supabase.User user) {
    return UserDto(
      id: user.id,
      username: user.userMetadata?['username'],
      profileImageUrl: user.userMetadata?['profileImageUrl'],
      email: user.email,
    );
  }

  factory UserDto.fromUserTable(UserTableData user) {
    return UserDto(
      id: user.id,
      username: user.username,
      profileImageUrl: user.profileImageUrl,
      email: user.email,
    );
  }
}
