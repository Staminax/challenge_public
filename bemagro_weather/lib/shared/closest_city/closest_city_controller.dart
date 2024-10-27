import 'package:bemagro_weather/interfaces/online_controller.dart';
import 'package:bemagro_weather/shared/closest_city/closest_city.dart';

class ClosestCityController extends OnlineController<ClosestCity> {
  static const String LATITUDE = 'lat';
  static const String LONGITUDE = 'lng';
  static const String NAME = 'name';

  @override
  ClosestCity fromMap(Map map) {
    return ClosestCity(
      lat: map[LATITUDE] ?? '',
      lng: map[LONGITUDE] ?? '',
      name: map[NAME] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap(ClosestCity obj) {
    return {
      LATITUDE: obj.lat,
      LONGITUDE: obj.lng,
      NAME: obj.name,
    };
  }
}
