import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/auth_provider.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 ProfilePage initialized');

    // Sử dụng addPostFrameCallback để đảm bảo gọi fetch sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfilePage();
    });
  }

  Future<void> _initializeProfilePage() async {
    if (_hasInitialized) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Đợi cho AuthProvider khởi tạo xong với số lần thử giới hạn
    int retryCount = 0;
    while (!authProvider.isInitialized && retryCount < 5) {
      debugPrint('⏳ Đang đợi AuthProvider khởi tạo... (lần $retryCount)');
      await Future.delayed(Duration(milliseconds: 200));
      retryCount++;
      if (!mounted) return;
    }

    if (!authProvider.isInitialized) {
      debugPrint('⚠️ AuthProvider không khởi tạo sau nhiều lần thử');
      _hasInitialized = true;
      return;
    }

    debugPrint(
      '🔍 AuthProvider đã khởi tạo. Trạng thái đăng nhập: ${authProvider.isAuthenticated}',
    );

    if (authProvider.isAuthenticated) {
      debugPrint('✅ Người dùng đã đăng nhập. Đang tải thông tin...');
      await _fetchUserProfile();
    } else {
      debugPrint('⚠️ Người dùng chưa đăng nhập.');
    }

    _hasInitialized = true;
  }

  Future<void> _fetchUserProfile() async {
    debugPrint('🔄 Starting to fetch user profile in ProfilePage');

    // Kiểm tra mounted trước khi cập nhật state
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.fetchUserProfile();

    debugPrint('✅ Fetch user profile completed with result: $result');

    // Kiểm tra mounted lần nữa trước khi cập nhật state và sử dụng context
    if (!mounted) return;

    // In thông tin user sau khi fetch xong
    final user = authProvider.user;
    if (user != null) {
      debugPrint('👤 USER DATA IN PROFILE PAGE:');
      debugPrint('   - ID: ${user.id}');
      debugPrint('   - Fullname: ${user.fullname}');
      debugPrint('   - Student ID: ${user.studentId}');
      debugPrint('   - Email: ${user.email}');

      // In toàn bộ thông tin để kiểm tra
      final userMap = {
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
      };
      debugPrint(
        '📊 COMPLETE USER DATA IN PROFILE PAGE: ${jsonEncode(userMap)}',
      );
    } else {
      debugPrint('❌ User is null in ProfilePage after fetching');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ Building ProfilePage UI');
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Thông Tin Cá Nhân",
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[900]),
            onPressed: () {
              debugPrint('🔄 Refresh button pressed');
              _fetchUserProfile();
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.user;
                  if (user == null) {
                    debugPrint('❌ User is null in Consumer builder');
                    return Center(
                      child: Text(
                        "Không thể tải thông tin người dùng",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  debugPrint('✅ Displaying user data for: ${user.fullname}');
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        color: Colors.grey[300],
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildReadOnlyField("Tên đầy đủ", user.fullname),
                              _buildReadOnlyField("MSSV", user.studentId),
                              _buildReadOnlyField("Email", user.email),
                              _buildReadOnlyField(
                                "Số điện thoại",
                                user.phoneNumber,
                              ),
                              _buildReadOnlyField("Địa chỉ", user.address),
                              if (user.department != null)
                                _buildReadOnlyField("Khoa", user.department!),
                              if (user.clazz != null)
                                _buildReadOnlyField("Lớp", user.clazz!),
                              if (user.dateOfBirth != null)
                                _buildReadOnlyField(
                                  "Ngày sinh",
                                  "${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}",
                                ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Xử lý xác nhận form
                                      debugPrint(
                                        '✅ Form validated successfully',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[900],
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Xác nhận",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  // Hàm tạo TextField chỉ đọc
  Widget _buildReadOnlyField(String label, String value) {
    // Debug cho mỗi field
    debugPrint('📝 Building field: $label = $value');
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
