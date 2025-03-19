import 'package:app_dtn/models/user.dart';
import 'package:app_dtn/models/auth_response.dart';
import 'package:app_dtn/models/api_response.dart';
import 'package:app_dtn/utils/constants.dart';
import 'package:app_dtn/services/api_service.dart';
import 'package:app_dtn/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
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

    await prefs.setString(ApiConstants.userKey, userData);
    debugPrint('✅ User data saved to storage with proper encoding');
  }

  // Lấy thông tin user đã lưu
  Future<User?> getUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(ApiConstants.userKey);

    if (userData != null) {
      try {
        debugPrint(
          '📘 Đọc dữ liệu user từ storage: ${userData.substring(0, min(100, userData.length))}...',
        );

        // Đảm bảo xử lý UTF-8 đúng cách
        final List<int> bytes = utf8.encode(userData);
        final String decodedData = utf8.decode(bytes, allowMalformed: true);
        final Map<String, dynamic> userMap = jsonDecode(decodedData);

        // Kiểm tra các chuỗi tiếng Việt trước khi chuyển thành User object
        userMap.forEach((key, value) {
          if (value is String) {
            userMap[key] = _sanitizeString(value);
          }
        });

        return User.fromJson(userMap);
      } catch (e) {
        debugPrint('❌ Error decoding user data: $e');
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

  // Cải tiến hàm _sanitizeString để xử lý tốt hơn tiếng Việt
  String _sanitizeString(String? value) {
    if (value == null) return 'null';

    // Xử lý ký tự đặc biệt và mã hóa UTF-8 đúng cách
    try {
      // Kiểm tra chuỗi bị mã hóa sai
      if (value.contains('Ä') ||
          value.contains('Æ') ||
          value.contains('á»') ||
          value.contains('Ã') ||
          value.contains('Ná»')) {
        debugPrint('🔧 Phát hiện chuỗi tiếng Việt bị mã hóa sai: "$value"');
        // Thử decode và encode lại với UTF-8
        List<int> bytes = utf8.encode(value);
        String decoded = utf8.decode(bytes, allowMalformed: true);
        debugPrint('🔧 Đã sửa thành: "$decoded"');
        return decoded.replaceAll(RegExp(r'[\r\n]'), ' ').trim();
      }
    } catch (e) {
      debugPrint('⚠️ Lỗi khi xử lý chuỗi tiếng Việt: $e');
    }

    return value.replaceAll(RegExp(r'[\r\n]'), ' ').trim();
  }

  // Nâng cấp phương thức lưu thông tin user
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

      // Kiểm tra mã hóa trước khi lưu
      final List<int> bytes = utf8.encode(userJson);
      final String encodedJson = utf8.decode(bytes, allowMalformed: true);

      // Sử dụng cùng key với _saveUserData
      await prefs.setString(ApiConstants.userKey, encodedJson);
      debugPrint('✅ User data saved to storage with enhanced UTF-8 encoding');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
    }
  }
}
