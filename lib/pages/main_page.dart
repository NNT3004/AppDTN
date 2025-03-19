import 'package:app_dtn/pages/eventpages/academic_events.dart';
import 'package:app_dtn/pages/eventpages/traditional_events.dart';
import 'package:app_dtn/pages/eventpages/union_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dtn/providers/event_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Không gọi fetchMyEvents trực tiếp trong initState
    // Thay vào đó, sử dụng addPostFrameCallback để đảm bảo
    // việc gọi diễn ra sau khi build frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && mounted) {
        _isInitialized = true;
        _fetchMyEvents();
      }
    });
  }

  // Hàm để lấy danh sách sự kiện của người dùng từ provider
  Future<void> _fetchMyEvents() async {
    if (!mounted) return;

    debugPrint('📱 MainPage: Đang tải sự kiện của NGƯỜI DÙNG...');
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      // Reset lỗi trước khi fetch
      eventProvider.resetError();

      await eventProvider.fetchMyEvents(refresh: true);

      if (mounted) {
        // Kiểm tra lỗi sau khi tải
        if (eventProvider.error != null) {
          debugPrint('❌ MainPage: Lỗi khi tải sự kiện: ${eventProvider.error}');
        } else {
          debugPrint('✅ MainPage: Tải sự kiện của người dùng thành công');
        }
      }
    } catch (e) {
      debugPrint('❌ MainPage: Lỗi ngoại lệ khi tải sự kiện của người dùng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "HOẠT ĐỘNG CỦA BẠN",
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Nút làm mới danh sách
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.blue[900]),
              onPressed: () {
                debugPrint('🔄 MainPage: Đang làm mới danh sách sự kiện...');
                _fetchMyEvents();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang làm mới danh sách sự kiện'),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.blue[900],
            labelColor: Colors.blue[900],
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Truyền Thống"),
              Tab(text: "Học Thuật"),
              Tab(text: "Liên Chi Đoàn"),
            ],
          ),
        ),
        body: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            // Hiển thị thông báo nếu đang tải
            if (eventProvider.isLoading && eventProvider.myEvents.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang tải danh sách sự kiện...'),
                  ],
                ),
              );
            }

            // Hiển thị thông báo lỗi nếu có
            if (eventProvider.error != null && eventProvider.myEvents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Đã xảy ra lỗi: ${eventProvider.error}',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchMyEvents,
                      child: Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            // Hiển thị TabBarView với dữ liệu đã được tải
            return TabBarView(
              children: [TraditionalEvents(), AcademicEvents(), UnionEvents()],
            );
          },
        ),
      ),
    );
  }
}
