import 'package:bemagro_weather/interfaces/offline_model.dart';
import 'package:bemagro_weather/shared/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class OfflineController<T extends OfflineModel> {
  static const String ID = 'id';

  final String tableName;
  final T table;
  final DbHelper? helper = DbHelper.instance;

  OfflineController(
    this.tableName,
    this.table,
  );

  Future<int> delete(int id) async {
    Database? database = await helper?.getDatabase;
    return database == null
        ? -1
        : await database.delete(tableName, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? database = await helper?.getDatabase;
    return database == null
        ? -1
        : await database.rawDelete('DELETE FROM $tableName');
  }

  Future<T?> first() async {
    Database? database = await helper?.getDatabase;
    List<Map<String, dynamic>> map =
        await database!.rawQuery('SELECT * FROM $tableName');
    if (map.isNotEmpty) {
      return fromMap(map.first);
    }
    return null;
  }

  T fromMap(Map<dynamic, dynamic> map);

  Future<List<T>> getAll({String order = ID}) async {
    Database? database = await helper?.getDatabase;
    List listMap = database == null
        ? []
        : await database.rawQuery('SELECT * FROM $tableName'
            ' ORDER BY $order');
    List<T> list = <T>[];
    for (Map m in listMap) {
      list.add(fromMap(m));
    }
    return list;
  }

  Future<List<T>> getList() async {
    return getListSql('SELECT * FROM $tableName');
  }

  Future<List<T>> getListSql(String sql, {List<dynamic>? params}) async {
    Database? database = await helper?.getDatabase;
    List listMap = database == null ? [] : await database.rawQuery(sql, params);
    List<T> list = <T>[];

    for (Map e in listMap) {
      list.add(fromMap(e));
    }

    return list;
  }

  Future<T?> getSql(String sql, {List<dynamic>? params}) async {
    Database? database = await helper?.getDatabase;
    List<Map> maps =
        database == null ? [] : await database.rawQuery(sql, params);

    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<T> insert(T obj) async {
    Database? database = await helper?.getDatabase;

    Map<String, dynamic> aux = toMap(obj);
    aux[OfflineController.ID] = null;

    obj.id = database == null ? -1 : await database.insert(tableName, aux);
    return obj;
  }

  Map<String, dynamic> toMap(T obj);

  Future<int> update(T obj) async {
    Database? database = await helper?.getDatabase;
    return database == null
        ? -1
        : await database.update(tableName, toMap(obj),
            where: '$ID = ?', whereArgs: [obj.id]);
  }
}
