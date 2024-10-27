import 'package:bemagro_weather/shared/weather_data/rain/rain.dart';
import 'package:bemagro_weather/shared/weather_data/weather/weather.dart';

class Current {
  int? dt;
  num? temp;
  num? feelsLike;
  int? pressure;
  int? humidity;
  num? uvi;
  int? clouds;
  num? windSpeed;
  List<Weather>? weather;
  Rain? rain;

  Current({
    this.dt,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.uvi,
    this.clouds,
    this.windSpeed,
    this.weather,
    this.rain,
  });

  Current.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    temp = json['temp'];
    feelsLike = json['feels_like'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    uvi = json['uvi'];
    clouds = json['clouds'];
    windSpeed = json['wind_speed'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    rain = json['rain'] != null ? Rain.fromJson(json['rain']) : null;
  }

  factory Current.placeholder() {
    return Current(
      dt: 0,
      temp: 0,
      feelsLike: 0,
      pressure: 0,
      humidity: 0,
      uvi: 0,
      clouds: 0,
      windSpeed: 0,
      weather: <Weather>[],
      rain: Rain.placeholder(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['wind_speed'] = windSpeed;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    if (rain != null) {
      data['rain'] = rain!.toJson();
    }
    return data;
  }
}
