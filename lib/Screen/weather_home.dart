import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/Services/services.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  WeatherData? weatherInfo; // Nullable
  bool isLoading = true; // Initialize to true
  final TextEditingController _cityController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load default weather data for a default city if needed
    myWeather('London'); // Replace with your default city if needed
  }

  Future<void> myWeather(String city) async {
    setState(() {
      isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedWeather = await WeatherServices().fetchWeather(city: city);
       ('Fetched Weather Data: ${fetchedWeather.toJson()}');
      setState(() {
        weatherInfo = fetchedWeather;
        isLoading = false;
      });
    } catch (e) {
      ('Error fetching weather data: $e');
      setState(() {
      
        isLoading = false;
        _errorMessage = 'Failed to load weather data';
      });
    }
  }

  void _handleSearch() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      myWeather(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            hintText: 'Enter city name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                        onPressed: _handleSearch,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : weatherInfo != null
                            ? SingleChildScrollView(
                                child: WeatherDetail(
                                  weather: weatherInfo!,
                                  formattedDate: formattedDate,
                                  formattedTime: formattedTime,
                                  constraints: constraints,
                                ),
                              )
                            : Text(
                                _errorMessage ?? 'No data available',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  final BoxConstraints constraints;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = constraints.maxWidth > 600;
    double iconSize = isDesktop ? 100.0 : 75.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Current address name
        Text(
          weather.name,
          style: TextStyle(
            fontSize: isDesktop ? 30 : 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        // Current temperature
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: TextStyle(
            fontSize: isDesktop ? 50 : 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // Weather condition
        if (weather.weather.isNotEmpty)
          Icon(
            _getWeatherIcon(weather.weather[0].main),
            size: iconSize,
            color: Colors.white,
          ),
        const SizedBox(height: 10),
        Text(
          weather.weather[0].description.toUpperCase(), // Display weather description
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        // Date and time
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        // More weather details
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherInfoCard(
                    icon: Icons.air,
                    title: "Wind",
                    value: "${weather.wind.speed} km/h",
                  ),
                  weatherInfoCard(
                    icon: Icons.thermostat_outlined,
                    title: "Max Temp",
                    value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
                  ),
                  weatherInfoCard(
                    icon: Icons.thermostat_outlined,
                    title: "Min Temp",
                    value: "${weather.minTemperature.toStringAsFixed(2)}°C",
                  ),
                ],
              ),
              const Divider(color: Colors.white70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherInfoCard(
                    icon: Icons.water_drop,
                    title: "Humidity",
                    value: "${weather.humidity}%",
                  ),
                  weatherInfoCard(
                    icon: Icons.compress,
                    title: "Pressure",
                    value: "${weather.pressure} hPa",
                  ),
                  weatherInfoCard(
                    icon: Icons.height,
                    title: "Sea-Level",
                    value: "${weather.seaLevel} m",
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toUpperCase()) {
      case 'clear':
        return Icons.wb_sunny; // Clear weather icon
      case 'clouds':
        return Icons.cloud; // Cloudy weather icon
      case 'rain':
        return Icons.beach_access; // Rainy weather icon
      case 'snow':
        return Icons.ac_unit; // Snowy weather icon
      case 'thunderstorm':
        return Icons.flash_on; // Thunderstorm icon
      case 'drizzle':
        return Icons.opacity; // Drizzle icon
      case 'mist':
        return Icons.blur_on; // Mist icon
      default:
        return Icons.help_outline; // Default icon for unknown conditions
    }
  }

  Column weatherInfoCard({required IconData icon, required String title, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
