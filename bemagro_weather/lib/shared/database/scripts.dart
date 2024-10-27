import 'package:bemagro_weather/interfaces/offline_controller.dart';
import 'package:bemagro_weather/shared/last_search/last_search_controller.dart';
import 'package:bemagro_weather/shared/search_history/search_history_controller.dart';

class HeartbeatScripts {
  static const String tbLastSearch = '''
          CREATE TABLE IF NOT EXISTS ${LastSearchController.TABLE_NAME} ( 
          ${OfflineController.ID}          INTEGER PRIMARY KEY AUTOINCREMENT, 
          ${LastSearchController.NAME}     VARCHAR(100), 
          ${LastSearchController.LAT}      VARCHAR(20), 
          ${LastSearchController.LNG}      VARCHAR(20),
          ${LastSearchController.WD_JSON}  TEXT);,

      ''';

  static const String tbSearchHistory =
      ''' CREATE TABLE IF NOT EXISTS ${SearchHistoryController.TABLE_NAME} ( 
          ${OfflineController.ID}              INTEGER PRIMARY KEY AUTOINCREMENT, 
          ${SearchHistoryController.NAME}      VARCHAR(100), 
          ${SearchHistoryController.UF}        CHAR(2),      
          ${SearchHistoryController.LATITUDE}  VARCHAR(20),  
          ${SearchHistoryController.LONGITUDE} VARCHAR(20)); 
      ''';
}
