import 'package:app_dtn/components/bottom_nav_bar.dart';
import 'package:app_dtn/models/main_page.dart';
import 'package:app_dtn/models/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //this selected index is to control the bottom nav bar
  int _selectedIndex = 0;
  // this method will update our select index
  // when the user taps on the bottom bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //pages to display
  final List<Widget> _pages = [
    //main page
    const MainPage(),
    //profile page
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.menu, color: Colors.blue[900]),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //logo
                DrawerHeader(
                  child: Image.asset(
                    'lib/images/logo.png',
                    //color: Colors.blue[900],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Divider(color: Colors.grey[800],),
                // ),
                // other pages
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.blue[900]),
                    title: Text(
                      'Màn hình chính',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.blue[900]),
                    title: Text(
                      'About',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.blue[900]),
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ),
            ),
          ],
        ),
      ),
      body:
          _pages.isNotEmpty && _selectedIndex < _pages.length
              ? _pages[_selectedIndex]
              : const Center(child: Text("Trang không tồn tại")),
    );
  }
}
