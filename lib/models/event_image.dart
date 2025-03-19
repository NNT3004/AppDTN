class EventImage {
  final int id;
  final int eventId;
  final String imageUrl;

  EventImage({required this.id, required this.eventId, required this.imageUrl});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'],
      eventId: json['eventId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'eventId': eventId, 'imageUrl': imageUrl};
  }
}
