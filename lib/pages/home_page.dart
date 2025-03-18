import 'package:app_dtn/components/bottom_nav_bar.dart';
import 'package:app_dtn/pages/events_page.dart';
import 'package:app_dtn/pages/main_page.dart';
import 'package:app_dtn/pages/profile_page.dart';
import 'package:app_dtn/pages/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến lưu trữ index của trang hiện tại để điều khiển thanh điều hướng
  int _selectedIndex = 0;

  // Hàm cập nhật index khi người dùng nhấn vào thanh điều hướng
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Danh sách các trang để hiển thị
  final List<Widget> _pages = [
    MainPage(), // Trang chính
    ProfilePage(), // Trang hồ sơ
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Màu nền của trang chính
      // Thanh điều hướng dưới cùng
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),

      // Thanh AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Loại bỏ bóng
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.menu, color: Colors.blue[900]),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Mở menu Drawer
                },
              ),
        ),
      ),

      // Menu Drawer (bên trái màn hình)
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Phần header với logo
                DrawerHeader(child: Image.asset('lib/images/logo.png')),

                // Mục "Màn hình chính"
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.blue[900]),
                    title: Text(
                      'Màn hình chính',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        ),
                  ),
                ),

                // Mục hoạt động
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.event, color: Colors.blue[900]),
                    title: Text(
                      'Hoạt động',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventsPage()),
                        ),
                  ),
                ),
              ],
            ),

            // Mục "Đăng xuất"
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                bottom: 25.0,
                right: 15.0,
              ),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.blue[900]),
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.blue[900]),
                ),
                onTap: () {
                  _showLogoutDialog(
                    context,
                  ); // Gọi hộp thoại xác nhận đăng xuất
                },
              ),
            ),
          ],
        ),
      ),

      // Nội dung trang hiện tại
      body:
          _pages.isNotEmpty && _selectedIndex < _pages.length
              ? _pages[_selectedIndex]
              : const Center(child: Text("Trang không tồn tại")),
    );
  }

  // Hộp thoại xác nhận đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xác nhận đăng xuất"),
          content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại nếu chọn "Không"
              },
              child: Text("Không"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                _logout(); // Gọi hàm đăng xuất nếu chọn "Có"
              },
              child: Text("Có", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý đăng xuất
  void _logout() {
    debugPrint("Đã đăng xuất!");
    // Điều hướng về màn hình đăng nhập và xóa toàn bộ lịch sử điều hướng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
