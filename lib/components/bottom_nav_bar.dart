import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int currentIndex;

  const MyBottomNavBar({
    super.key,
    required this.onTabChange,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '🏗️ BUILD: Đang xây dựng BottomNavBar với currentIndex = $currentIndex',
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        selectedIndex: currentIndex,
        color: Colors.grey[400],
        activeColor: Colors.blue[900],
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        gap: 8,
        onTabChange: (value) {
          debugPrint('👆 NAV_BAR: onTabChange gọi với giá trị $value');
          onTabChange?.call(value);
        },
        tabs: [
          GButton(icon: Icons.home, text: 'Màn hình chính'),
          GButton(icon: Icons.account_circle_sharp, text: 'Thông tin cá nhân'),
        ],
      ),
    );
  }
}
