import 'package:app_dtn/models/user.dart';

class AuthResponse {
  final String accessToken;
  final String role;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.role,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      role: json['role'] ?? '',
      user: User.fromJson(json['userResponse'] ?? {}),
    );
  }
}
