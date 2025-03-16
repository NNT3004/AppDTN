import 'package:flutter/material.dart';

class OtherEvents extends StatefulWidget {
  const OtherEvents({super.key});

  @override
  State<OtherEvents> createState() => _OtherEventsState();
}

class _OtherEventsState extends State<OtherEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.event_available_sharp, color: Colors.grey),
            title: Text(
              "Khác",
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