import 'package:flutter/material.dart';
import 'package:weather_sense/models/weather_model.dart';
import 'package:weather_sense/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('ddb6ba6fbbb61225e3648f7bd77bd733');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async{
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    
    //any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/partlyshower.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'night':
        return 'assets/night.json';
      default:
        return 'assets/sunny.json';
    }
  }
  
  //init state
  @override
  void initState() {
    super.initState();
    
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city..",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text('${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),),

            //weather condition
            Text(_weather?.mainCondition ?? "",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),)
          ],
        ),
      ),
    );
  }
}