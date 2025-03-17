import 'package:flutter/material.dart';

class AcademicEvents extends StatefulWidget {
  const AcademicEvents({super.key});

  @override
  State<AcademicEvents> createState() => _AcademicEventsState();
}

class _AcademicEventsState extends State<AcademicEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.auto_stories, color: Colors.green),
            title: Text(
              "Học Thuật",
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