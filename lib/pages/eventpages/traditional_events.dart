import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';

class TraditionalEvents extends StatefulWidget {
  const TraditionalEvents({super.key});

  @override
  State<TraditionalEvents> createState() => _TraditionalEventsState();
}

class _TraditionalEventsState extends State<TraditionalEvents> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        // Lọc các sự kiện "traditional" từ danh sách sự kiện của người dùng
        final traditionalEvents =
            eventProvider.myEvents
                .where(
                  (event) => event.eventType.toLowerCase() == 'traditional',
                )
                .toList();

        debugPrint(
          '📱 TraditionalEvents: Có ${traditionalEvents.length} sự kiện truyền thống',
        );

        if (traditionalEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Bạn chưa tham gia sự kiện truyền thống nào",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: traditionalEvents.length,
          itemBuilder: (context, index) {
            final event = traditionalEvents[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.local_fire_department, color: Colors.red),
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
                  debugPrint(
                    '📱 TraditionalEvents: Đã chọn sự kiện ID=${event.id}',
                  );

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
