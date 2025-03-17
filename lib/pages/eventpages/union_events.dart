import 'package:flutter/material.dart';

class UnionEvents extends StatefulWidget {
  const UnionEvents({super.key});

  @override
  State<UnionEvents> createState() => _UnionEventsState();
}

class _UnionEventsState extends State<UnionEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.groups, color: Colors.blue),
            title: Text(
              "Liên chi đoàn",
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