class Venue {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String timezone;
  final double? latitude;
  final double? longitude;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.timezone,
    this.latitude,
    this.longitude,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address']?['line1'] ?? '',
      city: json['city']?['name'] ?? '',
      state: json['state']?['name'] ?? '',
      country: json['country']?['name'] ?? '',
      postalCode: json['postalCode'] ?? '',
      timezone: json['timezone'] ?? '',
      latitude: double.tryParse(json['location']?['latitude'] ?? ''),
      longitude: double.tryParse(json['location']?['longitude'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'timezone': timezone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
