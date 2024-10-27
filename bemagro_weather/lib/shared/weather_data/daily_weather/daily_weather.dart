import 'package:bemagro_weather/shared/weather_data/daily_weather/dw_cloud_cover.dart';
import 'package:bemagro_weather/shared/weather_data/daily_weather/dw_precipitation.dart';
import 'package:bemagro_weather/shared/weather_data/daily_weather/dw_temperature.dart';
import 'package:bemagro_weather/shared/weather_data/daily_weather/dw_wind.dart';

class DailyWeather {
  double? lat;
  double? lon;
  String? tz;
  String? date;
  String? units;
  DWCloudCover? cloudCover;
  DWCloudCover? humidity;
  DWPrecipitation? precipitation;
  DWTemperature? temperature;
  DWCloudCover? pressure;
  DWWind? wind;

  DailyWeather(
      {this.lat,
      this.lon,
      this.tz,
      this.date,
      this.units,
      this.cloudCover,
      this.humidity,
      this.precipitation,
      this.temperature,
      this.pressure,
      this.wind});

  DailyWeather.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    tz = json['tz'];
    date = json['date'];
    units = json['units'];
    cloudCover = json['cloud_cover'] != null
        ? DWCloudCover.fromJson(json['cloud_cover'])
        : null;
    humidity = json['humidity'] != null
        ? DWCloudCover.fromJson(json['humidity'])
        : null;
    precipitation = json['precipitation'] != null
        ? DWPrecipitation.fromJson(json['precipitation'])
        : null;
    temperature = json['temperature'] != null
        ? DWTemperature.fromJson(json['temperature'])
        : null;
    pressure = json['pressure'] != null
        ? DWCloudCover.fromJson(json['pressure'])
        : null;
    wind = json['wind'] != null ? DWWind.fromJson(json['wind']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['tz'] = tz;
    data['date'] = date;
    data['units'] = units;
    if (cloudCover != null) {
      data['cloud_cover'] = cloudCover!.toJson();
    }
    if (humidity != null) {
      data['humidity'] = humidity!.toJson();
    }
    if (precipitation != null) {
      data['precipitation'] = precipitation!.toJson();
    }
    if (temperature != null) {
      data['temperature'] = temperature!.toJson();
    }
    if (pressure != null) {
      data['pressure'] = pressure!.toJson();
    }
    if (wind != null) {
      data['wind'] = wind!.toJson();
    }
    return data;
  }
}
