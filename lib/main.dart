import 'package:app_dtn/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/auth_provider.dart';
import 'package:app_dtn/pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ), // Đăng ký AuthProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Thêm các provider khác nếu cần
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'App DTN',
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            home:
                authProvider.isLoading
                    ? _buildLoadingScreen()
                    : authProvider.isAuthenticated
                    ? HomePage()
                    : LoginPage(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
