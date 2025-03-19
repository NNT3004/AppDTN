import 'package:app_dtn/models/event.dart';

class EventListResponse {
  final List<Event> events;
  final int totalPage;

  EventListResponse({required this.events, required this.totalPage});

  factory EventListResponse.fromJson(Map<String, dynamic> json) {
    return EventListResponse(
      events:
          (json['events'] as List?)?.map((e) => Event.fromJson(e)).toList() ??
          [],
      totalPage: json['totalPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((event) => event.toJson()).toList(),
      'totalPage': totalPage,
    };
  }
}
