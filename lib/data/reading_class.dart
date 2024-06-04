class Reading {
  final double temperatureDHT;
  final int humidity;
  final double pressure;
  final double airQuality;
  final int soilMoisture;
  final bool isRaining;
  final double rainfall;
  final String windDirection;
  final double windSpeed;

  Reading({
    required this.temperatureDHT,
    required this.humidity,
    required this.pressure,
    required this.airQuality,
    required this.soilMoisture,
    required this.isRaining,
    required this.rainfall,
    required this.windDirection,
    required this.windSpeed,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      temperatureDHT: (json['temperatureDHT'] as num).toDouble(),
      humidity: json['humidity'] as int,
      pressure: (json['pressure'] as num).toDouble(),
      airQuality: (json['airQuality'] as num).toDouble(),
      soilMoisture: json['soilMoisture'] as int,
      isRaining: json['isRaining'] as bool,
      rainfall: (json['rainfall'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );
  }
}
