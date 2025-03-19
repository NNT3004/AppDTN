import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isRegistered = false; // Trạng thái đăng ký

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi Tiết Sự Kiện",
          style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiến trình đăng ký
            Text(
              "Đã đăng ký: ${isRegistered ? "1" : "0"} / 100",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(),
            Text('Tình Nguyện Mùa Hè Xanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Chương trình tình nguyện giúp đỡ cộng đồng', style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 10),
            // Thông tin sự kiện
            _buildInfoText("📍 Địa điểm:", "Khu A"),
            _buildInfoText("⭐ Điểm phục vụ cộng đồng:", "20 điểm"),

            SizedBox(height: 10),
            Text(
              "✅ Các tiêu chí của sự kiện:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildBulletText("Đạo đức tốt"),
            _buildBulletText("Thể lực tốt"),
            _buildBulletText("Tình nguyện tốt"),
            _buildBulletText("Hội nhập tốt"),

            SizedBox(height: 10),
            _buildInfoText("📅 Ngày kết thúc đăng ký:", "10/04/2025"),
            _buildInfoText("📆 Hoạt động diễn ra từ ngày:", "10/03/2025 đến 20/04/2025"),

            Spacer(),

            // Nút đăng ký
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isRegistered
                    ? null // Vô hiệu hóa nút khi đã đăng ký
                    : () {
                        setState(() {
                          isRegistered = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đăng ký thành công!")),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRegistered ? Colors.grey : Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isRegistered ? "ĐÃ ĐĂNG KÝ" : "ĐĂNG KÝ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thông tin có tiêu đề
  Widget _buildInfoText(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(text: title, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: " $content"),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị danh sách gạch đầu dòng
  Widget _buildBulletText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 4),
      child: Row(
        children: [
          Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventDetailPage(),
    debugShowCheckedModeBanner: false,
  ));
}
