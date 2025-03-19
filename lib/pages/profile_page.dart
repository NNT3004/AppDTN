import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:app_dtn/providers/auth_provider.dart';

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
  int _buildCount = 0;
  bool isEditing = false; // Thêm khai báo biến isEditing ở đây

  // Thêm biến user để lưu thông tin người dùng
  Map<String, String> user = {
    'fullname': '',
    'studentId': '',
    'email': '',
    'phoneNumber': '',
    'address': '',
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint('🔵 INIT: ProfilePage được khởi tạo');

    // Sử dụng addPostFrameCallback để đảm bảo gọi fetch sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('⏱️ POST_FRAME: ProfilePage sẵn sàng khởi tạo dữ liệu');
      _initializeProfilePage();
    });
  }

  @override
  void dispose() {
    debugPrint('🔵 DISPOSE: ProfilePage bị hủy');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🔵 DEPENDENCIES: ProfilePage dependencies thay đổi');

    // Thêm đoạn code này để khởi tạo dữ liệu khi tab được chọn
    if (!_hasInitialized) {
      debugPrint(
        '🔄 DEPENDENCIES: ProfilePage chưa được khởi tạo, bắt đầu khởi tạo',
      );
      _initializeProfilePage();
    } else {
      debugPrint('✅ DEPENDENCIES: ProfilePage đã được khởi tạo trước đó');
    }
  }

  @override
  void activate() {
    super.activate();
    debugPrint('🔵 ACTIVATE: ProfilePage được kích hoạt');

    // Thêm đoạn này để làm mới dữ liệu khi tab được kích hoạt lại
    if (_hasInitialized) {
      debugPrint('🔄 ACTIVATE: ProfilePage đã khởi tạo, cập nhật lại dữ liệu');
      _refreshUserProfile();
    }
  }

  @override
  void deactivate() {
    debugPrint('🔵 DEACTIVATE: ProfilePage bị vô hiệu hóa');
    super.deactivate();
  }

  Future<void> _initializeProfilePage() async {
    debugPrint(
      '🔵 INITIALIZE: Bắt đầu khởi tạo ProfilePage, hasInitialized = $_hasInitialized',
    );
    if (_hasInitialized) {
      debugPrint(
        '⚠️ INITIALIZE: ProfilePage đã được khởi tạo trước đó, bỏ qua',
      );
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      debugPrint(
        '🔵 PROVIDER: Lấy AuthProvider, isInitialized = ${authProvider.isInitialized}, isAuthenticated = ${authProvider.isAuthenticated}',
      );
      debugPrint(
        '🔍 USER DATA IN PROVIDER: ${authProvider.user != null ? "CÓ DỮ LIỆU" : "KHÔNG CÓ DỮ LIỆU"}',
      );

      if (authProvider.user != null) {
        debugPrint('👤 USER DETAIL FROM PROVIDER:');
        debugPrint('   - ID: ${authProvider.user?.id}');
        debugPrint('   - Fullname: ${authProvider.user?.fullname}');
        debugPrint('   - StudentID: ${authProvider.user?.studentId}');
        debugPrint('   - Email: ${authProvider.user?.email}');
      }

      // Đợi cho AuthProvider khởi tạo xong với số lần thử giới hạn
      int retryCount = 0;
      while (!authProvider.isInitialized && retryCount < 5) {
        debugPrint(
          '⏳ WAIT: Đang đợi AuthProvider khởi tạo... (lần $retryCount)',
        );
        await Future.delayed(Duration(milliseconds: 200));
        retryCount++;
        if (!mounted) {
          debugPrint(
            '⚠️ NOT_MOUNTED: ProfilePage không còn mounted khi đợi AuthProvider',
          );
          return;
        }
      }

      if (!authProvider.isInitialized) {
        debugPrint('⚠️ TIMEOUT: AuthProvider không khởi tạo sau nhiều lần thử');
        _hasInitialized = true;
        return;
      }

      debugPrint(
        '🔍 AUTH_STATE: AuthProvider đã khởi tạo. Đăng nhập = ${authProvider.isAuthenticated}',
      );

      if (authProvider.isAuthenticated) {
        debugPrint('✅ AUTH_OK: Người dùng đã đăng nhập. Đang tải thông tin...');
        await _fetchUserProfile();
      } else {
        debugPrint('⚠️ AUTH_NO: Người dùng chưa đăng nhập.');
      }
    } catch (e) {
      debugPrint('❌ INIT_ERROR: Lỗi khi khởi tạo ProfilePage: $e');
    } finally {
      _hasInitialized = true;
      debugPrint('✅ INIT_DONE: ProfilePage đã hoàn tất khởi tạo');
    }
  }

  Future<void> _fetchUserProfile() async {
    debugPrint('🔄 Starting to fetch user profile in ProfilePage');

    // Kiểm tra mounted trước khi cập nhật state
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Kiểm tra xem đã có thông tin trong authProvider chưa
      if (authProvider.user != null) {
        debugPrint('✅ User data đã có sẵn trong AuthProvider, sử dụng luôn');
        debugPrint('👤 USER DETAIL BEFORE UPDATE:');
        debugPrint('   - Fullname: ${user['fullname']}');
        debugPrint('   - StudentID: ${user['studentId']}');
        debugPrint('   - Email: ${user['email']}');

        setState(() {
          // Cập nhật user map từ dữ liệu có sẵn
          user = {
            'fullname': authProvider.user?.fullname ?? '',
            'studentId': authProvider.user?.studentId ?? '',
            'email': authProvider.user?.email ?? '',
            'phoneNumber': authProvider.user?.phoneNumber ?? '',
            'address': authProvider.user?.address ?? '',
          };
          debugPrint('👤 USER DETAIL AFTER UPDATE:');
          debugPrint('   - Fullname: ${user['fullname']}');
          debugPrint('   - StudentID: ${user['studentId']}');
          debugPrint('   - Email: ${user['email']}');
          debugPrint('👤 Đã cập nhật thông tin user: ${json.encode(user)}');
        });
      } else {
        // Nếu chưa có, gọi API để lấy
        debugPrint('🔄 Chưa có dữ liệu user, gọi fetchUserProfile()');
        final result = await authProvider.fetchUserProfile();

        debugPrint('✅ Fetch user profile completed with result: $result');
        debugPrint(
          '👤 USER IN PROVIDER AFTER FETCH: ${authProvider.user != null ? "CÓ DỮ LIỆU" : "KHÔNG CÓ DỮ LIỆU"}',
        );

        // Cập nhật dữ liệu user từ authProvider sau khi fetch
        if (result && authProvider.user != null) {
          setState(() {
            user = {
              'fullname': authProvider.user?.fullname ?? '',
              'studentId': authProvider.user?.studentId ?? '',
              'email': authProvider.user?.email ?? '',
              'phoneNumber': authProvider.user?.phoneNumber ?? '',
              'address': authProvider.user?.address ?? '',
            };
            debugPrint(
              '👤 Đã cập nhật thông tin user sau khi fetch: ${json.encode(user)}',
            );
          });
        }
      }

      // Kiểm tra mounted lần nữa
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Lỗi khi tải thông tin người dùng: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Quan trọng cho AutomaticKeepAliveClientMixin
    _buildCount++;
    debugPrint('🏗️ BUILD: ProfilePage được xây dựng lần thứ $_buildCount');

    // Thêm log kiểm tra tab index
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    debugPrint(
      '🧩 BUILD: Kiểm tra tình trạng khởi tạo - hasInitialized = $_hasInitialized',
    );

    // Gọi trực tiếp API nếu chưa có dữ liệu
    if (!_isLoading &&
        user['fullname']?.isEmpty == true &&
        authProvider.isAuthenticated) {
      debugPrint('🚨 DIRECT_CALL: Gọi trực tiếp fetchUserProfile từ build');
      Future.microtask(
        () => authProvider.fetchUserProfile().then((success) {
          if (success && mounted) {
            debugPrint(
              '✅ DIRECT_SUCCESS: Gọi trực tiếp API thành công, cập nhật UI',
            );
            setState(() {
              user = {
                'fullname': authProvider.user?.fullname ?? '',
                'studentId': authProvider.user?.studentId ?? '',
                'email': authProvider.user?.email ?? '',
                'phoneNumber': authProvider.user?.phoneNumber ?? '',
                'address': authProvider.user?.address ?? '',
              };
            });
          }
        }),
      );
    }

    // Kiểm tra AuthProvider khi build
    debugPrint(
      '👤 BUILD_AUTH: User trong provider = ${authProvider.user?.fullname ?? "null"}',
    );
    debugPrint('👤 BUILD_LOCAL: User trong local = ${json.encode(user)}');

    // Nếu chưa có dữ liệu local nhưng có dữ liệu trong provider, cập nhật ngay
    if ((user['fullname']?.isEmpty ?? true) &&
        authProvider.user?.fullname != null) {
      debugPrint('🔄 BUILD_UPDATE: Cập nhật dữ liệu từ provider trong build');
      // Dùng Future.microtask để không cập nhật state trong build
      Future.microtask(() {
        if (mounted) {
          setState(() {
            user = {
              'fullname': authProvider.user?.fullname ?? '',
              'studentId': authProvider.user?.studentId ?? '',
              'email': authProvider.user?.email ?? '',
              'phoneNumber': authProvider.user?.phoneNumber ?? '',
              'address': authProvider.user?.address ?? '',
            };
            debugPrint(
              '👤 BUILD_UPDATED: Đã cập nhật dữ liệu trong microtask: ${json.encode(user)}',
            );
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Thông Tin Cá Nhân",
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Nút chỉnh sửa
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue[900]),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh đại diện
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/images/thinh.png'), // Avatar
                ),
              ),
              SizedBox(height: 20),

              // Các trường thông tin
              _buildTextField("Tên đầy đủ", "fullname"),
              _buildTextField("MSSV", "studentId"),
              _buildTextField("Email", "email"),
              _buildTextField("Số điện thoại", "phoneNumber"),
              _buildTextField("Địa chỉ", "address"),
              SizedBox(height: 20),

              // Nút lưu khi đang chỉnh sửa
              if (isEditing)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Lưu dữ liệu vào user
                      setState(() {
                        isEditing = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Thông tin đã được cập nhật!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Lưu",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Thay đổi cách hiển thị TextField - sử dụng controller thay vì initialValue
  Widget _buildTextField(String label, String key) {
    debugPrint('🔹 FIELD: Đang render field $key với giá trị "${user[key]}"');

    // Tạo controller mới với giá trị ban đầu từ user map
    final controller = TextEditingController(text: user[key]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        // Thay thế initialValue bằng controller
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: isEditing ? Colors.black87 : Colors.black54,
          fontSize: 16,
        ),
        validator: (value) {
          if (key == "email" && value != null && value.isNotEmpty) {
            bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ).hasMatch(value);
            if (!emailValid) {
              return "Email không hợp lệ";
            }
          }
          return null;
        },
        onSaved: (value) {
          if (value != null) {
            user[key] = value;
          }
        },
      ),
    );
  }

  // Thêm phương thức debug hiển thị text
  void _debugTextFields() {
    debugPrint('🔍 DEBUG TEXT FIELDS:');
    user.forEach((key, value) {
      debugPrint('   - $key: "$value" (length: ${value.length})');
    });
  }

  // Thêm hàm mới để làm mới dữ liệu mà không đặt _isLoading = true
  Future<void> _refreshUserProfile() async {
    debugPrint('🔄 REFRESH: Đang làm mới dữ liệu người dùng');
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      debugPrint(
        '👤 REFRESH: Provider user = ${authProvider.user?.fullname ?? "null"}',
      );

      if (authProvider.user != null) {
        setState(() {
          user = {
            'fullname': authProvider.user?.fullname ?? '',
            'studentId': authProvider.user?.studentId ?? '',
            'email': authProvider.user?.email ?? '',
            'phoneNumber': authProvider.user?.phoneNumber ?? '',
            'address': authProvider.user?.address ?? '',
          };
          debugPrint('👤 REFRESH: Đã cập nhật user data: ${json.encode(user)}');
        });
      }
    } catch (e) {
      debugPrint('❌ REFRESH ERROR: ${e.toString()}');
    }
  }
}
