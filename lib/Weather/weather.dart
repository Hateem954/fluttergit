// import 'package:flutter/material.dart';
// import 'package:weaather/models/weather_models.dart';
// import 'package:weaather/services/weather_service.dart';

// class WeatherApp extends StatefulWidget {
//   const WeatherApp({super.key});

//   @override
//   _WeatherState createState() => _WeatherState();
// }

// class _WeatherState extends State<WeatherApp> {
//   // api key
//   final _weatherService = WeatherService('957cb55a6ead2a6c464f296baa198157');
//   Weather? _weather;
//   //fetch weather
//   _fetchWeather() async {
//     // get the current city
//     String cityName = await _weatherService.getCurrentCityWeather();

//     // get the weather
//     try {
//       final weather = await _weatherService.getWeather(cityName);
//       setState(() {
//         _weather = weather;
//       });
//     }
//     // any errors
//     catch (e) {
//       print(e);
//     }
//   }

//   //init state
//   @override
//   void initState() {
//     super.initState();

//     _fetchWeather();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weather App'),
//         backgroundColor: Colors.amber,
//       ),
//       body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           //For city
//           children: Text(_weather?.cityName ?? "city... "),

// // for temperature
//           Text('${_weather?.temperature.round()}C')),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:weaather/models/weather_models.dart';
import 'package:weaather/services/weather_service.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<WeatherApp> {
  // API key
  final _weatherService = WeatherService('957cb55a6ead2a6c464f296baa198157');
  Weather? _weather;

  // Fetch weather
  Future<void> _fetchWeather() async {
    try {
      // Get the current city
      final cityName = await _weatherService.getCurrentCity();
      // Get the weather
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = null; // In case of error, set weather to null
      });
    }
  }

  // Get the path for the weather animation
 String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null) {
    return 'assets/sunny_and_cloudy_animation.json'; // Corrected path and file name
  }
  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloud_animation.json'; // Corrected path and file name
    case 'rain':
      return 'assets/sunny_and_rain_animation.json'; // Corrected path and file name
    case 'drizzle':
    case 'shower rain':
      return 'assets/sunny_and_cloudy_animation.json'; // Corrected path and file name
    default:
      return 'assets/sunny_and_cloudy_animation.json'; // Default animation
  }
}

  // Init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator() // Show loading indicator while fetching
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // City name at the top
                  Text(
                    _weather?.cityName ?? "City not found",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  // Lottie animation below the city name
                  SizedBox(
                    height: 200, // Adjust the height as needed
                    child: Lottie.asset(
                        getWeatherAnimation(_weather?.mainCondition)),
                  ),
                  // Weather temperature at the bottom
                  Text(
                    '${_weather?.temperature.round() ?? 0}°C',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  // Weather condition
                  Text(
                    _weather?.mainCondition ?? "",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
