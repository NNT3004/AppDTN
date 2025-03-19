import 'package:flutter/material.dart';
import 'package:app_dtn/models/event.dart';
import 'package:app_dtn/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  List<Event> _myEvents = [];
  Event? _selectedEvent;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _hasMoreEvents = true;
  int? _selectedEventId;

  // Getters
  List<Event> get events => _events;
  List<Event> get myEvents => _myEvents;
  Event? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMoreEvents => _hasMoreEvents;
  int? get selectedEventId => _selectedEventId;

  // Lấy danh sách sự kiện
  Future<void> fetchEvents({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _events = [];
      _hasMoreEvents = true;
    }

    if (!_hasMoreEvents) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _eventService.fetchEvents(
        page: _currentPage,
        limit: 10,
      );

      if (response.success && response.data != null) {
        final newEvents = response.data!.events;

        if (refresh) {
          _events = newEvents;
        } else {
          _events.addAll(newEvents);
        }

        _totalPages = response.data!.totalPage;
        _hasMoreEvents = _currentPage < _totalPages - 1;

        if (_hasMoreEvents) {
          _currentPage++;
        }

        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching events: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy chi tiết sự kiện
  Future<void> fetchEventDetails(int eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _eventService.fetchEventDetails(eventId);

      if (response.success && response.data != null) {
        _selectedEvent = response.data;
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching event details: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy danh sách sự kiện của người dùng
  Future<void> fetchMyEvents({bool refresh = false}) async {
    if (refresh) {
      _myEvents = [];
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _eventService.fetchMyEvents(
        page: 0, // Luôn lấy trang đầu tiên cho My Events
        limit: 50, // Limit lớn hơn vì thường ít người dùng sẽ có ít sự kiện
      );

      if (response.success && response.data != null) {
        _myEvents = response.data!.events;
        _error = null;
        debugPrint(
          '📱 EventProvider: Lấy thành công ${_myEvents.length} sự kiện của người dùng',
        );
      } else {
        _error = response.message;
        debugPrint(
          '❌ EventProvider: Lỗi khi lấy sự kiện của người dùng: $_error',
        );
      }
    } catch (e) {
      _error = e.toString();
      debugPrint(
        '❌ EventProvider: Lỗi ngoại lệ khi lấy sự kiện của người dùng: $_error',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đăng ký tham gia sự kiện
  Future<bool> registerEvent(int eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _eventService.registerEvent(eventId);

      if (response.success) {
        // Cập nhật lại sự kiện đã chọn nếu đang xem chi tiết
        if (_selectedEvent != null && _selectedEvent!.id == eventId) {
          await fetchEventDetails(eventId);
        }

        // Cập nhật lại danh sách sự kiện của người dùng
        await fetchMyEvents();

        _error = null;
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error registering for event: $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm tùy chọn reset state
  void resetState() {
    _events = [];
    _myEvents = [];
    _selectedEvent = null;
    _currentPage = 0;
    _totalPages = 0;
    _hasMoreEvents = true;
    _error = null;
    notifyListeners();
  }

  // Phương thức để đặt ID sự kiện được chọn
  void setSelectedEventId(int id) {
    _selectedEventId = id;
    notifyListeners();
  }

  // Tách riêng phương thức đặt ID và lấy chi tiết
  Future<void> setSelectedEventIdAndFetchDetails(int id) async {
    _selectedEventId = id;
    notifyListeners();

    // Đưa việc lấy chi tiết vào Future để tránh gọi trong quá trình build
    await Future.microtask(() async {
      await fetchEventDetails(id);
    });
  }

  // Thêm phương thức để reset lỗi
  void resetError() {
    _error = null;
    notifyListeners();
  }
}
