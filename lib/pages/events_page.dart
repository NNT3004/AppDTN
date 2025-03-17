import 'package:app_dtn/pages/eventpages/academic_events.dart';
import 'package:app_dtn/pages/eventpages/traditional_events.dart';
import 'package:app_dtn/pages/eventpages/union_events.dart';
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
      length: 3, // 3 options
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
              //Tab(text: "Nộp Minh Chứng"), // Chỉ thấy khi vuốt
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TraditionalEvents(),
            AcademicEvents(),
            UnionEvents(),
          ],
        ),
      ),
    );
  }
}
