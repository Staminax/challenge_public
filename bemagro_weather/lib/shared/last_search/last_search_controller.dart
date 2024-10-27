import 'package:bemagro_weather/interfaces/offline_controller.dart';
import 'package:bemagro_weather/shared/last_search/last_search.dart';

class LastSearchController extends OfflineController<LastSearch> {
  static const String TABLE_NAME = 'last_search';

  static const String NAME = 'name';
  static const String LAT = 'lat';
  static const String LNG = 'lng';
  static const String WD_JSON = 'wd_json';

  LastSearchController() : super(TABLE_NAME, LastSearch());

  @override
  LastSearch fromMap(Map map) {
    return LastSearch(
      id: map[OfflineController.ID] ?? 0,
      name: map[NAME] ?? '',
      lat: map[LAT] ?? '',
      lng: map[LNG] ?? '',
      weatherDataJSON: map[WD_JSON] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap(LastSearch obj) {
    return {
      OfflineController.ID: obj.id,
      NAME: obj.name,
      LAT: obj.lat,
      LNG: obj.lng,
      WD_JSON: obj.weatherDataJSON,
    };
  }
}
