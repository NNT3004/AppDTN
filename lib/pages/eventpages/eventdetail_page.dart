import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';
import 'package:app_dtn/models/event.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 EventDetailPage: Khởi tạo trang chi tiết sự kiện');

    // Đảm bảo gọi sau khi build frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final selectedId = eventProvider.selectedEventId;

      if (selectedId != null) {
        debugPrint(
          '📱 EventDetailPage: Đang tải chi tiết sự kiện ID=$selectedId',
        );
        eventProvider.fetchEventDetails(selectedId);
      } else {
        debugPrint('⚠️ EventDetailPage: Không có ID sự kiện được chọn');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy thông tin sự kiện'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  // Hàm xử lý khi người dùng đăng ký tham gia sự kiện
  Future<void> _registerEvent(int eventId) async {
    debugPrint('📱 EventDetailPage: Đang đăng ký sự kiện ID=$eventId');

    if (_isRegistering) {
      debugPrint('📱 EventDetailPage: Đang xử lý yêu cầu trước, bỏ qua');
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final result = await eventProvider.registerEvent(eventId);

      if (result) {
        debugPrint('✅ EventDetailPage: Đăng ký sự kiện thành công');

        // Cập nhật lại danh sách sự kiện của tôi
        await eventProvider.fetchMyEvents(refresh: true);

        // Thông báo thành công
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký tham gia sự kiện thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        debugPrint(
          '❌ EventDetailPage: Đăng ký sự kiện thất bại: ${eventProvider.error}',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đăng ký thất bại: ${eventProvider.error ?? "Không xác định"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ EventDetailPage: Lỗi khi đăng ký sự kiện: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  // Widget hiển thị thông tin sự kiện
  Widget _buildEventInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // Kiểm tra xem người dùng đã đăng ký sự kiện chưa
  bool _isAlreadyRegistered(Event event, List<Event> myEvents) {
    return myEvents.any((myEvent) => myEvent.id == event.id);
  }

  // Kiểm tra xem có thể đăng ký sự kiện hay không
  bool _canRegister(Event event) {
    final now = DateTime.now();
    return now.isAfter(event.registrationStartDate) &&
        now.isBefore(event.registrationEndDate) &&
        event.currentRegistrations < event.maxRegistrations;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        final event = eventProvider.selectedEvent;

        // Không gọi API nào ở đây, chỉ sử dụng dữ liệu có sẵn
        // Nếu cần làm mới dữ liệu, sử dụng ElevatedButton với onPressed
        // hoặc các tương tác người dùng khác

        // Hiển thị loading khi đang tải chi tiết sự kiện
        if (eventProvider.isLoading) {
          debugPrint('📱 EventDetailPage: Đang tải chi tiết sự kiện...');
          return const Center(child: CircularProgressIndicator());
        }

        // Xử lý trường hợp không có sự kiện được chọn
        if (event == null) {
          debugPrint('❌ EventDetailPage: Không có sự kiện nào được chọn');
          return const Center(child: Text('Không tìm thấy thông tin sự kiện'));
        }

        // Kiểm tra xem người dùng đã đăng ký chưa
        final isRegistered = _isAlreadyRegistered(
          event,
          eventProvider.myEvents,
        );
        final canRegister = _canRegister(event);

        debugPrint(
          '📱 EventDetailPage: Hiển thị sự kiện ID=${event.id}, tên=${event.name}',
        );
        debugPrint(
          '📱 EventDetailPage: Đã đăng ký: $isRegistered, Có thể đăng ký: $canRegister',
        );

        // Format ngày giờ
        final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiến trình đăng ký
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tiến trình đăng ký",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          Text(
                            "${event.currentRegistrations}/${event.maxRegistrations}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value:
                            event.maxRegistrations > 0
                                ? event.currentRegistrations /
                                    event.maxRegistrations
                                : 0,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[700]!,
                        ),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Thông tin chính của sự kiện
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            event.icon,
                            color: _getEventColor(event.eventType),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.eventType,
                            style: TextStyle(
                              color: _getEventColor(event.eventType),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Chi tiết sự kiện
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thông tin chi tiết",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEventInfo("Địa điểm:", event.location),
                      _buildEventInfo("Điểm:", "${event.score} điểm"),
                      _buildEventInfo(
                        "Thời gian:",
                        "${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}",
                      ),
                      _buildEventInfo(
                        "Thời gian đăng ký:",
                        "${dateFormat.format(event.registrationStartDate)} - ${dateFormat.format(event.registrationEndDate)}",
                      ),
                      _buildEventInfo("Trạng thái:", event.status),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Hình ảnh sự kiện
              if (event.eventImages.isNotEmpty)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hình ảnh sự kiện",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: event.eventImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    event.eventImages[index].imageUrl,
                                    width: 300,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) {
                                      debugPrint(
                                        '❌ EventDetailPage: Lỗi tải ảnh: $error',
                                      );
                                      return Container(
                                        width: 300,
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.error),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Nút đăng ký tham gia
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isRegistered || !canRegister || _isRegistering
                          ? null
                          : () => _registerEvent(event.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child:
                      _isRegistering
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            isRegistered
                                ? "Đã đăng ký tham gia"
                                : canRegister
                                ? "Đăng ký tham gia"
                                : "Hết thời gian đăng ký",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm lấy màu dựa vào loại sự kiện
  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'traditional':
        return Colors.red;
      case 'academic':
        return Colors.green;
      case 'union':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

void main() {
  runApp(
    MaterialApp(home: EventDetailPage(), debugShowCheckedModeBanner: false),
  );
}
