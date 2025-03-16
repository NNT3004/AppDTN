import 'package:flutter/material.dart';

class TraditionalEvents extends StatefulWidget {
  const TraditionalEvents({super.key});

  @override
  State<TraditionalEvents> createState() => _TraditionalEventsState();
}

class _TraditionalEventsState extends State<TraditionalEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.local_fire_department, color: Colors.red),
            title: Text(
              "Truyền thống",
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