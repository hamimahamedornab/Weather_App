class Loc {
  final String cityName;
  final double latitude;
  final double longitude;

  Loc({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  factory Loc.fromJson(Map<String, dynamic> json) {
    return Loc(
      cityName: json['local_names']['en'],
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}
