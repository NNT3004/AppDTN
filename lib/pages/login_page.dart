import 'package:app_dtn/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Dành cho các đơn vị đăng tải hoạt động và bộ phận xét duyệt hoạt động dành riêng cho sinh viên',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border:
                      OutlineInputBorder(), // Thêm viền xung quanh TextField
                  errorBorder: OutlineInputBorder(
                    // Viền khi có lỗi
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border:
                      OutlineInputBorder(), // Thêm viền xung quanh TextField
                  errorBorder: OutlineInputBorder(
                    // Viền khi có lỗi
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text('Quên mật khẩu?'),
              //   ),
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  elevation: 10,
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
