class Event {
  final String id;
  final String eventName;
  final DateTime eventDate;
  final String venue;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventName: json['eventName'],
      eventDate: DateTime.parse(json['eventDate']),
      venue: json['venue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'venue': venue,
    };
  }
}
