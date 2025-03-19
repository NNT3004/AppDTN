import 'package:flutter/material.dart';
import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';

class UnionEvents extends StatefulWidget {
  const UnionEvents({super.key});

  @override
  State<UnionEvents> createState() => _UnionEventsState();
}

class _UnionEventsState extends State<UnionEvents> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        // Lọc các sự kiện "union" từ danh sách sự kiện của người dùng
        final unionEvents =
            eventProvider.myEvents
                .where((event) => event.eventType.toLowerCase() == 'union')
                .toList();

        debugPrint(
          '📱 UnionEvents: Có ${unionEvents.length} sự kiện liên chi đoàn',
        );

        if (unionEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Bạn chưa tham gia sự kiện liên chi đoàn nào",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: unionEvents.length,
          itemBuilder: (context, index) {
            final event = unionEvents[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.groups, color: Colors.blue),
                title: Text(
                  event.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  debugPrint('📱 UnionEvents: Đã chọn sự kiện ID=${event.id}');
                  // Chỉ đặt ID, không gọi fetchEventDetails
                  Provider.of<EventProvider>(
                    context,
                    listen: false,
                  ).setSelectedEventId(event.id);

                  // Điều hướng đến trang chi tiết (trang này sẽ tự gọi fetchEventDetails trong initState)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventDetailPage()),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
