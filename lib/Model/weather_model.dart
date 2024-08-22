
// Main WeatherData class
class WeatherData {
  final Coord coord;
  final String name;
  final Temperature temperature;
  final List<Weather> weather;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int humidity;
  final int pressure;
  final int seaLevel;

  WeatherData({
    required this.coord,
    required this.name,
    required this.temperature,
    required this.weather,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.humidity,
    required this.pressure,
    required this.seaLevel,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      coord: Coord.fromJson(json['coord']),
      name: json['name'],
      temperature: Temperature.fromJson(json['main']),
      weather: (json['weather'] as List).map((i) => Weather.fromJson(i)).toList(),
      wind: Wind.fromJson(json['wind']),
      maxTemperature: json['main']['temp_max']?.toDouble() ?? 0.0, // Handle optional field
      minTemperature: json['main']['temp_min']?.toDouble() ?? 0.0, // Handle optional field
      humidity: json['main']['humidity'] ?? 0, // Handle optional field
      pressure: json['main']['pressure'] ?? 0, // Handle optional field
      seaLevel: json['main']['sea_level']?.toInt() ?? 0, // Handle optional field
    );
  }

  toJson() {}
}

// Coord class for latitude and longitude
class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon']?.toDouble() ?? 0.0,
      lat: json['lat']?.toDouble() ?? 0.0,
    );
  }
}

// Temperature class for current temperature
class Temperature {
  final double current;

  Temperature({required this.current});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      current: json['temp']?.toDouble() ?? 0.0, // Handle optional field
    );
  }
}

// Weather class for weather conditions
class Weather {
  final String main;
  final String description;

  Weather({required this.main, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'] ?? '', // Handle optional field
      description: json['description'] ?? '', // Handle optional field
    );
  }
}

// Wind class for wind speed
class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed']?.toDouble() ?? 0.0, // Handle optional field
    );
  }
}
