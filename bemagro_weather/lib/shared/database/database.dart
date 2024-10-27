import 'package:bemagro_weather/shared/database/db_helper.dart';
import 'package:bemagro_weather/shared/database/scripts.dart';
import 'package:sqflite/sqflite.dart';

class BemAgroWeatherDatabase {
  static const String DB_NAME = 'bemagro_weather.db';
  static const int DB_VERSION = 1;

  static final List<String> scripts = [
    HeartbeatScripts.tbLastSearch,
    HeartbeatScripts.tbSearchHistory,
  ];

  static final DbHelper instance = DbHelper(
    dbName: DB_NAME,
    dbVersion: DB_VERSION,
    scripts: scripts,
  );

  Future<Database?> get database async {
    return await instance.getDatabase;
  }
}
