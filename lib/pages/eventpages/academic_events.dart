import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';
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
              "IAI Hackathon 2025",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(" Cuộc thi lập trình “IAI HACKATHON 2024” – sân chơi hấp dẫn về công nghệ thông tin và trí tuệ nhân tạo."),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Mũi tên điều hướng
            onTap: 
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventDetailPage()),
                ),
          ),
        );
      },
    );
  }
}