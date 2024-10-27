import 'package:bemagro_weather/interfaces/offline_model.dart';

class SearchHistory extends OfflineModel {
  String name;
  String uf;
  String latitude;
  String longitude;

  SearchHistory({
    super.id = 0,
    this.name = '',
    this.uf = '',
    this.latitude = '',
    this.longitude = '',
  });
}
