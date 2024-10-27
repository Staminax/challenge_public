import 'package:bemagro_weather/shared/weather_data/daily_weather/dw_max.dart';

class DWWind {
  DWMax? max;

  DWWind({this.max});

  DWWind.fromJson(Map<String, dynamic> json) {
    max = json['max'] != null ? DWMax.fromJson(json['max']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (max != null) {
      data['max'] = max!.toJson();
    }
    return data;
  }
}
