import 'package:bemagro_weather/shared/weather_data/feels_like/feels_like.dart';
import 'package:bemagro_weather/shared/weather_data/temperature/temperature.dart';
import 'package:bemagro_weather/shared/weather_data/weather/weather.dart';

class Daily {
  int? dt;
  Temperature? temp;
  FeelsLike? feelsLike;
  int? pressure;
  int? humidity;
  num? windSpeed;
  List<Weather>? weather;
  int? clouds;
  num? rain;
  num? uvi;

  Daily(
      {this.dt,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.windSpeed,
      this.weather,
      this.clouds,
      this.rain,
      this.uvi});

  Daily.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    temp = json['temp'] != null ? Temperature.fromJson(json['temp']) : null;
    feelsLike = json['feels_like'] != null
        ? FeelsLike.fromJson(json['feels_like'])
        : null;
    pressure = json['pressure'];
    humidity = json['humidity'];
    windSpeed = json['wind_speed'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'];
    rain = json['rain'];
    uvi = json['uvi'];
  }

  factory Daily.placeholder() {
    return Daily(
      clouds: 0,
      dt: DateTime.now().millisecondsSinceEpoch,
      feelsLike: FeelsLike.placeholder(),
      humidity: 0,
      pressure: 0,
      rain: 0,
      temp: Temperature.placeholder(),
      uvi: 0,
      weather: <Weather>[],
      windSpeed: 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    if (temp != null) {
      data['temp'] = temp!.toJson();
    }
    if (feelsLike != null) {
      data['feels_like'] = feelsLike!.toJson();
    }
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['wind_speed'] = windSpeed;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['clouds'] = clouds;
    data['rain'] = rain;
    data['uvi'] = uvi;
    return data;
  }
}
