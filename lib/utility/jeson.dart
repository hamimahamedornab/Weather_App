class Jeson {
  String main;
  String weatherDescription;
  String weatherIcon;
  double temperature;
  double minTemperature;
  double maxTemperature;
  DateTime dateTime;

  Jeson({
    required this.main,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.dateTime,
  });

  factory Jeson.fromJson(Map<String, dynamic> json) {
    // json['dt']
    return Jeson(
      temperature: json['main']['temp'],
      weatherDescription: json['weather'][0]['description'],
      weatherIcon: json['weather'][0]['icon'],
      main: json['weather'][0]['main'],
      maxTemperature: json['main']['temp_max'],
      minTemperature: json['main']['temp_min'],
      dateTime: DateTime.now(),
    );
  }
}
