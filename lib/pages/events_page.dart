import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';
import 'package:app_dtn/models/event.dart';
import 'package:app_dtn/pages/eventpages/eventdetail_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 EventsPage: Khởi tạo trang hiển thị tất cả sự kiện');
    // Thêm listener cho scroll để tải thêm dữ liệu khi cuộn xuống
    _scrollController.addListener(_scrollListener);

    // Sử dụng addPostFrameCallback để đảm bảo không gọi trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadEvents();
      }
    });
  }

  @override
  void dispose() {
    debugPrint('📱 EventsPage: Hủy trang sự kiện');
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Hàm xử lý sự kiện scroll để tải thêm dữ liệu
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      debugPrint('📱 EventsPage: Đã cuộn đến cuối danh sách, tải thêm sự kiện');
      _loadMoreEvents();
    }
  }

  // Tải sự kiện lần đầu
  Future<void> _loadEvents() async {
    if (!mounted) return;

    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (!_isLoading && eventProvider.events.isEmpty) {
      debugPrint('📱 EventsPage: Bắt đầu tải TẤT CẢ sự kiện lần đầu');
      setState(() {
        _isLoading = true;
      });

      await eventProvider.fetchEvents(refresh: true);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('📱 EventsPage: Hoàn thành tải TẤT CẢ sự kiện lần đầu');
      }
    }
  }

  // Tải thêm dữ liệu khi scroll xuống cuối
  Future<void> _loadMoreEvents() async {
    if (!mounted) return;

    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (!_isLoading && eventProvider.hasMoreEvents) {
      debugPrint(
        '📱 EventsPage: Bắt đầu tải thêm sự kiện, trang ${eventProvider.currentPage + 1}',
      );
      setState(() {
        _isLoading = true;
      });

      await eventProvider.fetchEvents();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('📱 EventsPage: Hoàn thành tải thêm sự kiện');
      }
    } else {
      debugPrint(
        '📱 EventsPage: Không cần tải thêm sự kiện (isLoading=$_isLoading, hasMoreEvents=${eventProvider.hasMoreEvents})',
      );
    }
  }

  // Làm mới danh sách sự kiện
  Future<void> _refreshEvents() async {
    if (!mounted) return;

    debugPrint('📱 EventsPage: Làm mới danh sách TẤT CẢ sự kiện');
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    await eventProvider.fetchEvents(refresh: true);
    debugPrint('📱 EventsPage: Hoàn thành làm mới danh sách TẤT CẢ sự kiện');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 EventsPage: Đang xây dựng giao diện');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "TẤT CẢ HOẠT ĐỘNG",
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          final events = eventProvider.events;
          final isLoading = eventProvider.isLoading;
          final hasError = eventProvider.error != null;

          debugPrint(
            '📱 EventsPage: Số lượng sự kiện: ${events.length}, đang tải: $isLoading, có lỗi: $hasError',
          );

          return RefreshIndicator(
            onRefresh: _refreshEvents,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Hiển thị danh sách sự kiện
                if (events.isEmpty && !isLoading && !hasError)
                  const SliverFillRemaining(
                    child: Center(child: Text("Không có sự kiện nào")),
                  )
                else if (hasError && events.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Đã có lỗi xảy ra: ${eventProvider.error}",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshEvents,
                            child: const Text("Thử lại"),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < events.length) {
                            final event = events[index];
                            return _buildEventCard(context, event);
                          } else if (eventProvider.hasMoreEvents) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        childCount:
                            events.length +
                            (eventProvider.hasMoreEvents ? 1 : 0),
                      ),
                    ),
                  ),

                // Hiển thị loading nếu đang tải và chưa có dữ liệu
                if (isLoading && events.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget hiển thị một card sự kiện
  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          debugPrint('📱 EventsPage: Đã chọn sự kiện ID=${event.id}');

          // Thay đổi cách gọi Provider
          final eventProvider = Provider.of<EventProvider>(
            context,
            listen: false,
          );
          eventProvider.setSelectedEventId(event.id);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventDetailPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị ảnh sự kiện nếu có
            if (event.eventImages.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  event.eventImages.first.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    debugPrint('❌ EventsPage: Lỗi tải ảnh sự kiện: $error');
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.error)),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loại sự kiện và điểm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Loại sự kiện
                      Row(
                        children: [
                          Icon(
                            event.icon,
                            size: 16,
                            color: _getEventColor(event.eventType),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.eventType,
                            style: TextStyle(
                              color: _getEventColor(event.eventType),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Điểm
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${event.score} điểm'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tên sự kiện
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Mô tả ngắn
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 12),

                  // Thông tin thêm: Địa điểm và thời gian
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
