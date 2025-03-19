import 'package:app_dtn/pages/eventpages/academic_events.dart';
import 'package:app_dtn/pages/eventpages/traditional_events.dart';
import 'package:app_dtn/pages/eventpages/union_events.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "HOẠT ĐỘNG CỦA BẠN",
            style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue[900],
            labelColor: Colors.blue[900],
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Truyền Thống"),
              Tab(text: "Học Thuật"),
              Tab(text: "Liên Chi Đoàn"),
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
