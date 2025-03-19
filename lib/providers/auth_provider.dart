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
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initialize();
  }

  // Khởi tạo và lấy thông tin từ local storage
  Future<void> _initialize() async {
    _isLoading = true;
    _isInitialized = false;
    notifyListeners();
    debugPrint('🔄 Đang khởi tạo AuthProvider...');

    try {
      _isAuthenticated = await _authService.isLoggedIn();
      debugPrint('🔐 Trạng thái đăng nhập: $_isAuthenticated');

      if (_isAuthenticated) {
        _user = await _authService.getUserFromStorage();
        debugPrint(
          '👤 Dữ liệu người dùng từ storage: ${_user != null ? 'Có' : 'Không có'}',
        );

        if (_user == null) {
          debugPrint(
            '⚠️ Không tìm thấy dữ liệu người dùng trong storage. Thử lấy từ API...',
          );
          await fetchUserProfile().then((success) {
            debugPrint('🔄 Kết quả lấy thông tin từ API: $success');
          });
        } else {
          // Log thông tin người dùng
          debugPrint('✅ Dữ liệu người dùng từ storage:');
          debugPrint('   - ID: ${_user?.id}');
          debugPrint('   - Tên: ${_user?.fullname}');
          debugPrint('   - Email: ${_user?.email}');
        }

        if (_user == null) {
          _isAuthenticated = false;
          debugPrint(
            '❌ Vẫn không có dữ liệu người dùng. Đặt lại trạng thái đăng nhập.',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Lỗi khi khởi tạo: $e');
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
      debugPrint('✅ Hoàn tất khởi tạo AuthProvider.');
    }
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

  // Thêm phương thức để lấy profile người dùng
  Future<bool> fetchUserProfile() async {
    // Loại bỏ biến isLocalLoading không sử dụng
    _error = null;
    // Chỉ gọi notifyListeners() một lần ở cuối
    debugPrint('🔄 Fetching user profile...');

    try {
      final response = await _authService.getUserProfile();

      if (response.success && response.data != null) {
        _user = response.data;
        _error = null;

        // In chi tiết thông tin user trong provider
        debugPrint('👤 USER PROFILE RECEIVED IN PROVIDER:');
        debugPrint('   - ID: ${_user?.id}');
        debugPrint('   - Fullname: ${_user?.fullname}');
        debugPrint('   - Student ID: ${_user?.studentId}');
        debugPrint('   - Email: ${_user?.email}');
        debugPrint('   - Department: ${_user?.department}');

        // Loại bỏ dòng lưu vào storage vì không có phương thức này
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error fetching user profile: $_error');
      notifyListeners();
      return false;
    }
  }
}
