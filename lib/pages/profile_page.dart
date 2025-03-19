import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Dữ liệu người dùng
  Map<String, String> user = {
    "fullname": "Nguyễn Ngọc Thịnh",
    "studentId": "102210377",
    "email": "nguyenvana@example.com",
    "phoneNumber": "0123456789",
    "address": "123 Đường ABC, Đà Nẵng",
  };

  bool isEditing = false; // Trạng thái chỉnh sửa

  @override
  Widget build(BuildContext context) {
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
