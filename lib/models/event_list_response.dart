import 'package:app_dtn/models/event.dart';
import 'package:flutter/foundation.dart';

class EventListResponse {
  final List<Event> events;
  final int totalPage;

  EventListResponse({required this.events, required this.totalPage});

  factory EventListResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Ghi log để kiểm tra cấu trúc JSON nhận được
      debugPrint('🔍 Parsing JSON data: ${json.keys.toList()}');

      // Xử lý trường hợp 'events' không phải là list
      List<Event> eventsList = [];

      if (json.containsKey('events')) {
        if (json['events'] is List) {
          eventsList =
              (json['events'] as List)
                  .map((e) => Event.fromJson(e as Map<String, dynamic>))
                  .toList();
          debugPrint('✅ Parsed ${eventsList.length} events from JSON');
        } else {
          debugPrint(
            '⚠️ Warning: events field is not a List: ${json['events']}',
          );
        }
      } else {
        debugPrint('⚠️ Warning: JSON does not contain events field');
        // Thử xem có phải API trả về mảng trực tiếp không
        if (json is List) {
          eventsList =
              (json as List)
                  .map((e) => Event.fromJson(e as Map<String, dynamic>))
                  .toList();
          debugPrint('✅ Parsed ${eventsList.length} events from direct array');
        }
      }

      // Xử lý trường hợp 'totalPage' không phải là int
      int totalPages = 0;
      if (json.containsKey('totalPage')) {
        if (json['totalPage'] is int) {
          totalPages = json['totalPage'];
        } else if (json['totalPage'] != null) {
          totalPages = int.tryParse(json['totalPage'].toString()) ?? 0;
          debugPrint('⚠️ Warning: totalPage not an int: ${json['totalPage']}');
        }
      } else if (json.containsKey('totalPages')) {
        // Kiểm tra tên trường khác
        if (json['totalPages'] is int) {
          totalPages = json['totalPages'];
        } else if (json['totalPages'] != null) {
          totalPages = int.tryParse(json['totalPages'].toString()) ?? 0;
        }
      }

      return EventListResponse(events: eventsList, totalPage: totalPages);
    } catch (e) {
      debugPrint('❌ Error parsing EventListResponse: $e');
      debugPrint('📄 JSON data: $json');
      // Trả về đối tượng rỗng thay vì ném lỗi
      return EventListResponse(events: [], totalPage: 0);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((event) => event.toJson()).toList(),
      'totalPage': totalPage,
    };
  }
}
