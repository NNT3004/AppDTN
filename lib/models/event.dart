import 'package:flutter/material.dart';
import 'package:app_dtn/models/event_image.dart';

enum EventType { traditional, academic, union }

class Event {
  final int id;
  final String name;
  final String description;
  final String location;
  final int score;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final int maxRegistrations;
  final int currentRegistrations;
  final String eventType;
  final List<EventImage> eventImages;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.score,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.registrationStartDate,
    required this.registrationEndDate,
    required this.maxRegistrations,
    required this.currentRegistrations,
    required this.eventType,
    required this.eventImages,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        score: json['score'] ?? 0,
        status: json['status'] ?? '',
        startDate:
            json['startDate'] != null
                ? DateTime.parse(json['startDate'])
                : DateTime.now(),
        endDate:
            json['endDate'] != null
                ? DateTime.parse(json['endDate'])
                : DateTime.now(),
        registrationStartDate:
            json['registrationStartDate'] != null
                ? DateTime.parse(json['registrationStartDate'])
                : DateTime.now(),
        registrationEndDate:
            json['registrationEndDate'] != null
                ? DateTime.parse(json['registrationEndDate'])
                : DateTime.now(),
        maxRegistrations: json['maxRegistrations'] ?? 0,
        currentRegistrations: json['currentRegistrations'] ?? 0,
        eventType: json['eventType'] ?? '',
        eventImages:
            (json['eventImages'] as List?)
                ?.map((image) => EventImage.fromJson(image))
                .toList() ??
            [],
      );
    } catch (e) {
      // Đảm bảo luôn trả về một đối tượng Event ngay cả khi có lỗi
      debugPrint('Error parsing Event: $e');
      return Event(
        id: 0,
        name: '',
        description: '',
        location: '',
        score: 0,
        status: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        registrationStartDate: DateTime.now(),
        registrationEndDate: DateTime.now(),
        maxRegistrations: 0,
        currentRegistrations: 0,
        eventType: '',
        eventImages: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        'score': score,
        'status': status,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'registrationStartDate': registrationStartDate.toIso8601String(),
        'registrationEndDate': registrationEndDate.toIso8601String(),
        'maxRegistrations': maxRegistrations,
        'currentRegistrations': currentRegistrations,
        'eventType': eventType,
        'eventImages': eventImages.map((image) => image.toJson()).toList(),
      };
    } catch (e) {
      // Đảm bảo luôn trả về một Map ngay cả khi có lỗi
      debugPrint('Error converting Event to JSON: $e');
      return {
        'id': 0,
        'name': '',
        'description': '',
        'location': '',
        'score': 0,
        'status': '',
        'startDate': DateTime.now().toIso8601String(),
        'endDate': DateTime.now().toIso8601String(),
        'registrationStartDate': DateTime.now().toIso8601String(),
        'registrationEndDate': DateTime.now().toIso8601String(),
        'maxRegistrations': 0,
        'currentRegistrations': 0,
        'eventType': '',
        'eventImages': [],
      };
    }
  }

  // Helper để lấy icon tương ứng với loại sự kiện
  IconData get icon {
    switch (eventType.toLowerCase()) {
      case 'traditional':
        return Icons.local_fire_department;
      case 'academic':
        return Icons.auto_stories;
      case 'union':
        return Icons.groups;
      default:
        return Icons
            .event; // Giá trị mặc định nếu không khớp với bất kỳ case nào
    }
  }

  // Helper để lấy màu tương ứng với loại sự kiện
  Color get color {
    switch (eventType.toLowerCase()) {
      case 'traditional':
        return Colors.red;
      case 'academic':
        return Colors.green;
      case 'union':
        return Colors.blue;
      default:
        return Colors
            .grey; // Giá trị mặc định nếu không khớp với bất kỳ case nào
    }
  }
}
