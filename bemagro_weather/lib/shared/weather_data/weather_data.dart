import 'package:bemagro_weather/shared/weather_data/alert/alert.dart';
import 'package:bemagro_weather/shared/weather_data/current/current.dart';
import 'package:bemagro_weather/shared/weather_data/daily/daily.dart';

class WeatherData {
  num? lat;
  num? lon;
  Current? current;
  List<Daily>? daily;
  List<Alert>? alerts;

  WeatherData({
    this.lat,
    this.lon,
    this.current,
    this.daily,
    this.alerts,
  });

  WeatherData.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];

    current =
        json['current'] != null ? Current.fromJson(json['current']) : null;

    if (json['daily'] != null) {
      daily = <Daily>[];
      json['daily'].forEach((v) {
        daily!.add(Daily.fromJson(v));
      });
    }

    if (json['alerts'] != null) {
      alerts = <Alert>[];
      json['alerts'].forEach((v) {
        alerts!.add(Alert.fromJson(v));
      });
    }
  }

  factory WeatherData.placeholder() {
    return WeatherData(
      alerts: <Alert>[],
      current: Current.placeholder(),
      daily: <Daily>[],
      lat: 0,
      lon: 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    if (current != null) {
      data['current'] = current!.toJson();
    }
    if (daily != null) {
      data['daily'] = daily!.map((v) => v.toJson()).toList();
    }
    if (alerts != null) {
      data['alerts'] = alerts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
