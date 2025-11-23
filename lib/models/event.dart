import 'venue.dart';
import 'attraction.dart';

class Event {
  final String id;
  final String name;
  final String url;
  final String locale;
  final String status;
  final String  eventDate;
  final String salesStart;
  final String salesEnd;
  final String image;
  final Venue venue;
  final List<Attraction> attractions;

  Event({
    required this.id,
    required this.name,
    required this.url,
    required this.locale,
    required this.status,
    required this.eventDate,
    required this.salesStart,
    required this.salesEnd,
    required this.image,
    required this.venue,
    required this.attractions,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      locale: json['locale'] ?? '',
      status: json['dates']?['status']?['code'] ?? '',
      eventDate: json['dates']?['start']?['localDate'] ?? '',
      salesStart: json['sales']?['public']?['startDateTime'] ?? '',
      salesEnd: json['sales']?['public']?['endDateTime'] ?? '',
      image: (json['images'] as List?)?.first?['url'] ?? '',
      venue: Venue.fromJson(json['_embedded']?['venues']?[0] ?? {}),
      attractions: (json['_embedded']?['attractions'] as List<dynamic>?)
          ?.map((a) => Attraction.fromJson(a))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'locale': locale,
      'status': status,
      'eventDate': eventDate,
      'salesStart': salesStart,
      'salesEnd': salesEnd,
      'image': image,
      'venue': venue.toJson(),
      'attractions': attractions.map((a) => a.toJson()).toList(),
    };
  }
}
