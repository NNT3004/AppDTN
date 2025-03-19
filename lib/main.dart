import 'package:app_dtn/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/auth_provider.dart';
import 'package:app_dtn/pages/login_page.dart';
import 'package:app_dtn/providers/event_provider.dart';

void main() {
  debugPrint('🚀 APP: Khởi động ứng dụng');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🏗️ BUILD: Đang xây dựng MyApp');
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        debugPrint(
          '👤 AUTH: Trạng thái đăng nhập = ${authProvider.isAuthenticated}, đang tải = ${authProvider.isLoading}',
        );

        // Chỉ kiểm tra isLoading khi app khởi động lần đầu, KHÔNG dùng cho các thao tác cập nhật
        if (!authProvider.isInitialized) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'App DTN',
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            home: _buildLoadingScreen(),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App DTN',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: authProvider.isAuthenticated ? HomePage() : LoginPage(),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
