import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 4 options
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "HOẠT ĐỘNG",
            style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
          centerTitle: true, // Căn giữa tiêu đề
          bottom: TabBar(
            isScrollable: true, // Cho phép vuốt để xem Option 4
            indicatorColor: Colors.blue[900],
            labelColor: Colors.blue[900],
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Làm đậm chữ
            tabs: [
              Tab(text: "Truyền Thống"),
              Tab(text: "Học Thuật"),
              Tab(text: "Liên Chi Đoàn"),
              Tab(text: "Khác"), // Chỉ thấy khi vuốt
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OptionScreen(title: "Truyền Thống"),
            OptionScreen(title: "Học Thuật"),
            OptionScreen(title: "Liên Chi Đoàn"),
            OptionScreen(title: "Khác"),
          ],
        ),
      ),
    );
  }
}

class OptionScreen extends StatelessWidget {
  final String title;
  const OptionScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.event, color: Colors.blue),
            title: Text(
              "$title $index",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.fsfsfsfsfsfsfs"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Mũi tên điều hướng
            onTap: () {
              // Xử lý khi bấm vào mục
            },
          ),
        );
      },
    );
  }
}
