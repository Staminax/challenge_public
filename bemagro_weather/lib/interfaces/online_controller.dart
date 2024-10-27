import 'package:bemagro_weather/interfaces/online_model.dart';

abstract class OnlineController<T extends OnlineModel> {
  T fromMap(Map<dynamic, dynamic> map);
  Map<String, dynamic> toMap(T obj);
}
