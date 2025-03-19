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

  // Lấy danh sách tất cả sự kiện
  Future<ApiResponse<EventListResponse>> fetchEvents({
    required int page,
    required int limit,
    String? keyword,
    String? eventType,
  }) async {
    // Xây dựng URL với các tham số
    final queryParams = {
      'page': page.toString(), // Chuyển đổi int sang String cho query params
      'limit': limit.toString(), // Chuyển đổi int sang String cho query params
    };

    // Thêm các tham số tùy chọn nếu có
    if (keyword != null && keyword.isNotEmpty) {
      queryParams['keyword'] = keyword;
    }
    if (eventType != null && eventType.isNotEmpty) {
      queryParams['eventType'] = eventType;
    }

    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/all?page=$page&limit=$limit';
    debugPrint('🔍 Fetching events from URL: $url');
    debugPrint(
      '📝 Request parameters - page: $page, limit: $limit, keyword: $keyword, eventType: $eventType',
    );

    try {
      // Lấy dữ liệu thô từ API
      final rawResponse = await _apiService.get(
        '${ApiConstants.eventsEndpoint}/all', // Sử dụng đường dẫn đã có trong constants
        queryParams: queryParams,
        fromJson: (json) => json, // Giữ nguyên JSON để xử lý thủ công
      );

      if (!rawResponse.success) {
        debugPrint('❌ Failed to fetch events: ${rawResponse.message}');
        return ApiResponse(
          success: false,
          message: rawResponse.message,
          statusCode: rawResponse.statusCode,
        );
      }

      // Xử lý dữ liệu nhận được
      debugPrint('🔍 Raw events data type: ${rawResponse.data.runtimeType}');

      EventListResponse eventListResponse;

      // Xử lý các định dạng dữ liệu khác nhau
      if (rawResponse.data is Map &&
          (rawResponse.data as Map).containsKey('events')) {
        eventListResponse = EventListResponse.fromJson(
          rawResponse.data as Map<String, dynamic>,
        );
        debugPrint(
          '✅ Processed standard format with events array (${eventListResponse.events.length} events)',
        );
      } else if (rawResponse.data is List) {
        try {
          final events =
              (rawResponse.data as List)
                  .map((item) => Event.fromJson(item as Map<String, dynamic>))
                  .toList();
          eventListResponse = EventListResponse(events: events, totalPage: 1);
          debugPrint(
            '✅ Processed events list into EventListResponse (${events.length} events)',
          );
        } catch (e) {
          debugPrint('❌ Error parsing events list: $e');
          return ApiResponse(
            success: false,
            message: 'Lỗi phân tích danh sách sự kiện: $e',
            statusCode: rawResponse.statusCode,
          );
        }
      } else {
        debugPrint('⚠️ Unknown data format for events, returning empty list');
        eventListResponse = EventListResponse(events: [], totalPage: 0);
      }

      return ApiResponse(
        success: true,
        message: 'Lấy danh sách sự kiện thành công',
        data: eventListResponse,
        statusCode: rawResponse.statusCode,
      );
    } catch (e) {
      debugPrint('❌ Exception in fetchEvents: $e');
      return ApiResponse(
        success: false,
        message: 'Lỗi khi lấy danh sách sự kiện: $e',
        statusCode: 500,
      );
    }
  }

  // Lấy chi tiết sự kiện
  Future<ApiResponse<Event>> fetchEventDetails(int eventId) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}/all/$eventId';
    debugPrint('🔍 Fetching event details from URL: $url');

    final response = await _apiService.get<Event>(
      '${ApiConstants.eventsEndpoint}/all/$eventId',
      fromJson: (data) => Event.fromJson(data),
    );

    if (!response.success) {
      debugPrint('❌ Failed to fetch event details: ${response.message}');
    } else {
      debugPrint('✅ Successfully fetched event details');
    }

    return response;
  }

  // Lấy danh sách sự kiện của người dùng
  Future<ApiResponse<EventListResponse>> fetchMyEvents({
    required int page,
    required int limit,
  }) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.myEventsEndpoint}?page=$page&limit=$limit';
    debugPrint('🔍 Fetching my events from URL: $url');
    debugPrint('📝 Request parameters - page: $page, limit: $limit');

    try {
      // Lấy dữ liệu thô từ API
      final rawResponse = await _apiService.get(
        ApiConstants.myEventsEndpoint,
        queryParams: {
          'page': page.toString(), // Chuyển đổi int sang String
          'limit': limit.toString(), // Chuyển đổi int sang String
        },
        fromJson: (json) => json, // Giữ nguyên JSON để xử lý thủ công
      );

      if (!rawResponse.success) {
        debugPrint('❌ Failed to fetch my events: ${rawResponse.message}');
        return ApiResponse(
          success: false,
          message: rawResponse.message,
          statusCode: rawResponse.statusCode,
        );
      }

      // Kiểm tra và xử lý dữ liệu nhận được
      debugPrint('🔍 Raw my events data type: ${rawResponse.data.runtimeType}');

      EventListResponse eventListResponse;

      // Trường hợp 1: nếu là Map và có trường "events" -> định dạng giống all events
      if (rawResponse.data is Map &&
          (rawResponse.data as Map).containsKey('events')) {
        eventListResponse = EventListResponse.fromJson(
          rawResponse.data as Map<String, dynamic>,
        );
        debugPrint(
          '✅ Processing my events as standard format with events array',
        );
      }
      // Trường hợp 2: nếu là Map nhưng không có trường "events" -> là một sự kiện đơn lẻ
      else if (rawResponse.data is Map) {
        try {
          // Tạo một sự kiện từ dữ liệu
          final event = Event.fromJson(
            rawResponse.data as Map<String, dynamic>,
          );
          // Đóng gói vào EventListResponse với mảng chỉ chứa 1 sự kiện này
          eventListResponse = EventListResponse(events: [event], totalPage: 1);
          debugPrint('✅ Processed single event into EventListResponse');
        } catch (e) {
          debugPrint('❌ Error parsing single event: $e');
          return ApiResponse(
            success: false,
            message: 'Lỗi phân tích sự kiện: $e',
            statusCode: rawResponse.statusCode,
          );
        }
      }
      // Trường hợp 3: nếu là List -> danh sách sự kiện không có totalPage
      else if (rawResponse.data is List) {
        try {
          final events =
              (rawResponse.data as List)
                  .map((item) => Event.fromJson(item as Map<String, dynamic>))
                  .toList();
          eventListResponse = EventListResponse(events: events, totalPage: 1);
          debugPrint('✅ Processed events list into EventListResponse');
        } catch (e) {
          debugPrint('❌ Error parsing events list: $e');
          return ApiResponse(
            success: false,
            message: 'Lỗi phân tích danh sách sự kiện: $e',
            statusCode: rawResponse.statusCode,
          );
        }
      }
      // Trường hợp khác: trả về danh sách rỗng
      else {
        debugPrint(
          '⚠️ Unknown data format for my events, returning empty list',
        );
        eventListResponse = EventListResponse(events: [], totalPage: 0);
      }

      return ApiResponse(
        success: true,
        message: 'Lấy sự kiện thành công',
        data: eventListResponse,
        statusCode: rawResponse.statusCode,
      );
    } catch (e) {
      debugPrint('❌ Exception in fetchMyEvents: $e');
      return ApiResponse(
        success: false,
        message: 'Lỗi khi lấy sự kiện: $e',
        statusCode: 500,
      );
    }
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
