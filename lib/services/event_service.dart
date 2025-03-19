import 'package:app_dtn/models/event.dart';
import 'package:app_dtn/models/event_list_response.dart';
import 'package:app_dtn/models/api_response.dart';
import 'package:app_dtn/utils/constants.dart';
import 'package:app_dtn/services/api_service.dart';
import 'package:flutter/foundation.dart';

class EventService {
  final ApiService _apiService = ApiService();

  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  // Lấy danh sách sự kiện với phân trang
  Future<ApiResponse<EventListResponse>> fetchEvents({
    required int page,
    required int limit,
  }) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}?page=$page&limit=$limit';
    debugPrint('🔍 Fetching events from URL: $url');
    debugPrint('📝 Request parameters - page: $page, limit: $limit');

    final response = await _apiService.get<EventListResponse>(
      '${ApiConstants.eventsEndpoint}?page=$page&limit=$limit',
      fromJson: (data) => EventListResponse.fromJson(data),
    );

    if (!response.success) {
      debugPrint('❌ Failed to fetch events: ${response.message}');
    } else {
      debugPrint('✅ Successfully fetched events');
    }

    return response;
  }

  // Lấy chi tiết sự kiện theo ID
  Future<ApiResponse<Event>> fetchEventDetails(int eventId) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/$eventId';
    debugPrint('🔍 Fetching event details from URL: $url');
    debugPrint('📝 Request parameters - eventId: $eventId');

    final response = await _apiService.get<Event>(
      '${ApiConstants.eventsEndpoint}/$eventId',
      fromJson: (data) => Event.fromJson(data),
    );

    if (!response.success) {
      debugPrint('❌ Failed to fetch event details: ${response.message}');
    } else {
      debugPrint('✅ Successfully fetched event details');
    }

    return response;
  }

  // Lấy danh sách sự kiện của người dùng hiện tại
  Future<ApiResponse<EventListResponse>> fetchMyEvents({
    required int page,
    required int limit,
  }) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/my-events';
    debugPrint('🔍 Fetching my events from URL: $url');
    debugPrint('📝 Request parameters - page: $page, limit: $limit');

    final response = await _apiService.post<EventListResponse>(
      '${ApiConstants.eventsEndpoint}/my-events',
      body: {'page': page, 'limit': limit},
      fromJson: (data) => EventListResponse.fromJson(data),
    );

    if (!response.success) {
      debugPrint('❌ Failed to fetch my events: ${response.message}');
    } else {
      debugPrint('✅ Successfully fetched my events');
    }

    return response;
  }

  // Đăng ký tham gia sự kiện
  Future<ApiResponse<void>> registerEvent(int eventId) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.registrationsEndpoint}/$eventId';
    debugPrint('🔍 Registering for event from URL: $url');
    debugPrint('📝 Request parameters - eventId: $eventId');

    final response = await _apiService.post<void>(
      '${ApiConstants.registrationsEndpoint}/$eventId',
      fromJson: null,
    );

    if (response.success) {
      debugPrint('✅ Successfully registered for event');
    } else {
      debugPrint('❌ Failed to register for event: ${response.message}');
    }

    return response;
  }

  // Tạo mã QR cho sự kiện
  Future<ApiResponse<String>> generateEventQRCode(int eventId) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/generateQR/$eventId';
    debugPrint('🔍 Generating QR code from URL: $url');
    debugPrint('📝 Request parameters - eventId: $eventId');

    final response = await _apiService.get<String>(
      '${ApiConstants.eventsEndpoint}/generateQR/$eventId',
      fromJson: (data) => data.toString(),
    );

    if (!response.success) {
      debugPrint('❌ Failed to generate QR code: ${response.message}');
    } else {
      debugPrint('✅ Successfully generated QR code');
    }

    return response;
  }
}
