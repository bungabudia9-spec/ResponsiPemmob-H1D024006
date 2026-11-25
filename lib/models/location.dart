class Location {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1; // Provinsi / Wilayah

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'],
      admin1: json['admin1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
