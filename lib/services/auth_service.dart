import 'package:app_dtn/models/user.dart';
import 'package:app_dtn/models/auth_response.dart';
import 'package:app_dtn/models/api_response.dart';
import 'package:app_dtn/utils/constants.dart';
import 'package:app_dtn/services/api_service.dart';
import 'package:app_dtn/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

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
    debugPrint('Sending login request for username: $username');
    final response = await _apiService.post<AuthResponse>(
      ApiConstants.loginEndpoint,
      requiresAuth: false,
      body: {'username': username, 'password': password},
      fromJson: (data) => AuthResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _tokenService.saveToken(response.data!.accessToken);
      await _tokenService.saveRole(response.data!.role);
      await _saveUserData(response.data!.user);
      debugPrint('Login successful, token and user data saved');
    } else {
      debugPrint('Login failed: ${response.message}');
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
    debugPrint('User data saved to storage');
  }

  // Lấy thông tin user đã lưu
  Future<User?> getUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(ApiConstants.userKey);

    if (userData != null) {
      try {
        return User.fromJson(jsonDecode(userData));
      } catch (e) {
        debugPrint('Error decoding user data: $e');
        return null;
      }
    }

    return null;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _tokenService.clearAllData();
    debugPrint('User logged out, all data cleared');
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    return await _tokenService.hasToken();
  }

  // Lấy thông tin profile của người dùng
  Future<ApiResponse<User>> getUserProfile() async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.userProfileEndpoint}';
    debugPrint('🔍 Fetching user profile from URL: $url');

    try {
      final response = await _apiService.get<User>(
        ApiConstants.userProfileEndpoint,
        fromJson: (data) {
          // Bảo vệ việc parse dữ liệu
          try {
            debugPrint('🔍 Parsing user data from JSON: ${jsonEncode(data)}');
            return User.fromJson(data);
          } catch (e) {
            debugPrint('❌ Error parsing user data: $e');
            debugPrint('❌ Raw data received: ${jsonEncode(data)}');
            rethrow;
          }
        },
      );

      if (!response.success) {
        debugPrint('❌ Failed to fetch user profile: ${response.message}');
        debugPrint('❌ Status code: ${response.statusCode}');
      } else {
        debugPrint('✅ Successfully fetched user profile');
        // In chi tiết thông tin user nhận được
        if (response.data != null) {
          final User user = response.data!;
          debugPrint('👤 USER DETAILS:');
          debugPrint('   - ID: ${user.id}');
          debugPrint('   - Fullname: ${_sanitizeString(user.fullname)}');
          debugPrint('   - Student ID: ${_sanitizeString(user.studentId)}');
          debugPrint('   - Email: ${_sanitizeString(user.email)}');
          debugPrint('   - Phone: ${_sanitizeString(user.phoneNumber)}');
          debugPrint('   - Department: ${_sanitizeString(user.department)}');
          debugPrint('   - Class: ${_sanitizeString(user.clazz)}');
          debugPrint('   - DOB: ${user.dateOfBirth}');
          debugPrint('   - Active: ${user.isActive}');

          // Lưu thông tin người dùng mới vào storage
          await _saveUserToStorage(user);
        }
      }

      // In thông tin response data nếu có
      if (response.data != null) {
        try {
          final userData =
              response.data!
                  .toJson(); // Sử dụng phương thức toJson() từ model User
          debugPrint('📋 USER DATA JSON: ${jsonEncode(userData)}');
        } catch (e) {
          debugPrint('❌ Error encoding user data: $e');
        }
      }

      return response;
    } catch (e) {
      debugPrint('❌ Exception in getUserProfile: $e');
      return ApiResponse(
        success: false,
        message: 'Lỗi xử lý dữ liệu: $e',
        statusCode: 500,
      );
    }
  }

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> _saveUserToStorage(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode({
        'id': user.id,
        'fullname': _sanitizeString(user.fullname),
        'studentId': _sanitizeString(user.studentId),
        'email': _sanitizeString(user.email),
        'phoneNumber': _sanitizeString(user.phoneNumber),
        'address': _sanitizeString(user.address),
        'username': _sanitizeString(user.username),
        'dateOfBirth': user.dateOfBirth?.toIso8601String(),
        'isActive': user.isActive,
        'department': _sanitizeString(user.department),
        'clazz': _sanitizeString(user.clazz),
      });

      await prefs.setString(ApiConstants.userKey, userJson);
      debugPrint('✅ User data saved to storage');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
    }
  }

  // Hàm xử lý chuỗi an toàn để tránh lỗi khi hiển thị
  String _sanitizeString(String? value) {
    if (value == null) return 'null';
    return value.replaceAll(RegExp(r'[\r\n]'), ' ').trim();
  }

  // Lưu thông tin người dùng vào SharedPreferences (phương thức public)
  Future<void> saveUserToStorage(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode({
        'id': user.id,
        'fullname': _sanitizeString(user.fullname),
        'studentId': _sanitizeString(user.studentId),
        'email': _sanitizeString(user.email),
        'phoneNumber': _sanitizeString(user.phoneNumber),
        'address': _sanitizeString(user.address),
        'username': _sanitizeString(user.username),
        'dateOfBirth': user.dateOfBirth?.toIso8601String(),
        'isActive': user.isActive,
        'department': _sanitizeString(user.department),
        'clazz': _sanitizeString(user.clazz),
      });

      await prefs.setString('user_data', userJson);
      debugPrint('✅ User data saved to storage');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
    }
  }
}
