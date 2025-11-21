class Event {
  final String id;
  final String name;
  final String imageUrl;
  final String date;
  final String venue;

  Event({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.date,
    required this.venue,
  });

  factory Event.fromTicketmaster(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      imageUrl: json['images'][0]['url'],
      date: json['dates']['start']['localDate'] ?? '',
      venue: json['_embedded']['venues'][0]['name'] ?? '',
    );
  }
}
