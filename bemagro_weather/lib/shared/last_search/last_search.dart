import 'package:bemagro_weather/interfaces/offline_model.dart';

class LastSearch extends OfflineModel {
  String name;
  String lat;
  String lng;
  String weatherDataJSON;

  LastSearch({
    super.id = 0,
    this.name = '',
    this.lat = '',
    this.lng = '',
    this.weatherDataJSON = '',
  });
}
