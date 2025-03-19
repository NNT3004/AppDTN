import 'package:flutter/material.dart';
import 'package:app_dtn/models/user.dart';
import 'package:app_dtn/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  String? _role;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;

  AuthProvider() {
    _initialize();
  }

  // Khởi tạo và lấy thông tin từ local storage
  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();
    debugPrint('Initializing AuthProvider...');

    _isAuthenticated = await _authService.isLoggedIn();
    debugPrint('Is authenticated: $_isAuthenticated');

    if (_isAuthenticated) {
      _user = await _authService.getUserFromStorage();
      debugPrint('User loaded from storage: $_user');

      if (_user == null) {
        _isAuthenticated = false;
        debugPrint('User is null, setting isAuthenticated to false');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Đăng nhập
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    debugPrint('Attempting login with username: $username');

    try {
      final response = await _authService.login(username, password);
      debugPrint('Login response: $response');

      if (response.success && response.data != null) {
        _isAuthenticated = true;
        _user = response.data!.user;
        _role = response.data!.role;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      debugPrint('Login error: $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    debugPrint('Logging out...');

    await _authService.logout();

    _isAuthenticated = false;
    _user = null;
    _role = null;

    _isLoading = false;
    notifyListeners();
  }
}
