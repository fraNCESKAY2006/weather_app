import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/Model/weather_model.dart';

class WeatherServices {
  final String _apiKey = '079ae9166db01530e451985e94bb75ab'; // Replace with your API key

  Future<WeatherData> fetchWeather({required String city}) async {
    // Encode the city name for use in the URL
    final encodedCity = Uri.encodeComponent(city);
    final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$encodedCity&appid=$_apiKey&units=metric"
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherData.fromJson(data);
    } else {
      // Print the error response for debugging
      ('Error: ${response.statusCode}');
      ('Response body: ${response.body}');
      throw Exception('Failed to load weather data');
    }
  }
}
