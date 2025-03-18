import 'package:flutter/material.dart';

enum EventType { traditional, academic, union }

class Event {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final DateTime date;
  final String location;
  final String organizer;
  final bool isRegistered;
  final String? imageUrl;
  final int maxParticipants;
  final int currentParticipants;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.location,
    required this.organizer,
    this.isRegistered = false,
    this.imageUrl,
    this.maxParticipants = 0,
    this.currentParticipants = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    EventType getType(String typeStr) {
      switch (typeStr.toLowerCase()) {
        case 'traditional':
          return EventType.traditional;
        case 'academic':
          return EventType.academic;
        case 'union':
          return EventType.union;
        default:
          return EventType.traditional;
      }
    }

    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: getType(json['type'] ?? 'traditional'),
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      location: json['location'] ?? '',
      organizer: json['organizer'] ?? '',
      isRegistered: json['isRegistered'] ?? false,
      imageUrl: json['imageUrl'],
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    String getTypeString(EventType type) {
      switch (type) {
        case EventType.traditional:
          return 'traditional';
        case EventType.academic:
          return 'academic';
        case EventType.union:
          return 'union';
      }
    }

    return {
      'id': id,
      'title': title,
      'description': description,
      'type': getTypeString(type),
      'date': date.toIso8601String(),
      'location': location,
      'organizer': organizer,
      'isRegistered': isRegistered,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
    };
  }

  // Helper để lấy icon tương ứng với loại sự kiện
  IconData get icon {
    switch (type) {
      case EventType.traditional:
        return Icons.local_fire_department;
      case EventType.academic:
        return Icons.auto_stories;
      case EventType.union:
        return Icons.groups;
    }
  }

  // Helper để lấy màu tương ứng với loại sự kiện
  Color get color {
    switch (type) {
      case EventType.traditional:
        return Colors.red;
      case EventType.academic:
        return Colors.green;
      case EventType.union:
        return Colors.blue;
    }
  }
}
