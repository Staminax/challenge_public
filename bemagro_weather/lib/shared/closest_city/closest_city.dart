import 'package:bemagro_weather/interfaces/online_model.dart';
import 'package:bemagro_weather/shared/weather_data/weather_data.dart';

class ClosestCity extends OnlineModel {
  String lng;
  String lat;
  String name;
  WeatherData? weatherData;

  ClosestCity({
    this.lng = '',
    this.lat = '',
    this.name = '',
    this.weatherData,
  });
}
