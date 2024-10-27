import 'package:bemagro_weather/interfaces/offline_controller.dart';
import 'package:bemagro_weather/shared/search_history/search_history.dart';

class SearchHistoryController extends OfflineController<SearchHistory> {
  static const String TABLE_NAME = 'search_history';

  static const String NAME = 'name';
  static const String UF = 'uf';
  static const String LATITUDE = 'lat';
  static const String LONGITUDE = 'lon';

  SearchHistoryController() : super(TABLE_NAME, SearchHistory());

  @override
  SearchHistory fromMap(Map map) {
    return SearchHistory(
      id: map[OfflineController.ID] ?? 0,
      name: map[NAME] ?? '',
      uf: map[UF] ?? '',
      latitude: map[LATITUDE] ?? '',
      longitude: map[LONGITUDE] ?? '',
    );
  }

  Future<List<SearchHistory>> getSearchHistory() async {
    String sql = 'SELECT * FROM $TABLE_NAME';

    return await super.getListSql(sql);
  }

  @override
  Map<String, dynamic> toMap(SearchHistory obj) {
    return {
      OfflineController.ID: obj.id,
      NAME: obj.name,
      UF: obj.uf,
      LATITUDE: obj.latitude,
      LONGITUDE: obj.longitude,
    };
  }
}
