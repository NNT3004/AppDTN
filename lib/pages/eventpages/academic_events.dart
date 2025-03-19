import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';

class AcademicEvents extends StatefulWidget {
  const AcademicEvents({super.key});

  @override
  State<AcademicEvents> createState() => _AcademicEventsState();
}

class _AcademicEventsState extends State<AcademicEvents> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        // Lọc các sự kiện "academic" từ danh sách sự kiện của người dùng
        final academicEvents =
            eventProvider.myEvents
                .where((event) => event.eventType.toLowerCase() == 'academic')
                .toList();

        debugPrint(
          '📱 AcademicEvents: Có ${academicEvents.length} sự kiện học thuật',
        );

        if (academicEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Bạn chưa tham gia sự kiện học thuật nào",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: academicEvents.length,
          itemBuilder: (context, index) {
            final event = academicEvents[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.auto_stories, color: Colors.green),
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
                    '📱 AcademicEvents: Đã chọn sự kiện ID=${event.id}',
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
