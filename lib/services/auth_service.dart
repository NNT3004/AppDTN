import 'package:app_dtn/models/user.dart';
import 'package:app_dtn/models/auth_response.dart';
import 'package:app_dtn/models/api_response.dart';
import 'package:app_dtn/utils/constants.dart';
import 'package:app_dtn/services/api_service.dart';
import 'package:app_dtn/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final ApiService _apiService = ApiService();
  final TokenService _tokenService = TokenService();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Đăng nhập
  Future<ApiResponse<AuthResponse>> login(
    String username,
    String password,
  ) async {
    final response = await _apiService.post<AuthResponse>(
      ApiConstants.loginEndpoint,
      requiresAuth: false,
      body: {'username': username, 'password': password},
      fromJson: (data) => AuthResponse.fromJson(data),
    );

    // Lưu token và thông tin user nếu thành công
    if (response.success && response.data != null) {
      await _tokenService.saveToken(response.data!.accessToken);
      await _tokenService.saveRole(response.data!.role);
      await _saveUserData(response.data!.user);
    }

    return response;
  }

  // Lưu thông tin user
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode({
      'id': user.id,
      'fullname': user.fullname,
      'studentId': user.studentId,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'address': user.address,
      'username': user.username,
      'dateOfBirth': user.dateOfBirth?.toIso8601String(),
      'isActive': user.isActive,
      'department': user.department,
      'clazz': user.clazz,
    });

    await prefs.setString(ApiConstants.userKey, userData);
  }

  // Lấy thông tin user đã lưu
  Future<User?> getUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(ApiConstants.userKey);

    if (userData != null) {
      try {
        return User.fromJson(jsonDecode(userData));
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _tokenService.clearAllData();
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    return await _tokenService.hasToken();
  }
}
