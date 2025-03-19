import 'package:flutter/material.dart';

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
  }

  @override
  void activate() {
    super.activate();
    debugPrint('🔵 ACTIVATE: ProfilePage được kích hoạt');
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
        '🔵 PROVIDER: Lấy AuthProvider, isInitialized = ${authProvider.isInitialized}',
      );

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
      // Sử dụng phương thức mới không làm thay đổi isLoading chung
      final result = await authProvider.fetchUserProfile();

      debugPrint('✅ Fetch user profile completed with result: $result');

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

  bool isEditing = false; // Trạng thái chỉnh sửa

  @override
  Widget build(BuildContext context) {
    super.build(context); // Quan trọng cho AutomaticKeepAliveClientMixin
    _buildCount++;
    debugPrint('🏗️ BUILD: ProfilePage được xây dựng lần thứ $_buildCount');
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
                  child: Text("Lưu", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo TextField có thể chỉnh sửa
  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: user[key],
        readOnly: !isEditing, // Chỉ cho phép chỉnh sửa khi bật chế độ edit
        onChanged: (value) {
          user[key] = value; // Cập nhật giá trị mới vào user
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: isEditing ? Colors.white : Colors.grey[300], // Chỉ đổi màu khi chỉnh sửa
        ),
      ),
    );
  }
}
