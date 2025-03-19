import 'package:flutter/material.dart';
import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';
class UnionEvents extends StatefulWidget {
  const UnionEvents({super.key});

  @override
  State<UnionEvents> createState() => _UnionEventsState();
}

class _UnionEventsState extends State<UnionEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.groups, color: Colors.blue),
            title: Text(
              "Hiến máu nhân đạo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Hiến máu nhân đạo sẽ được tổ chức tại trường DUT"),
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