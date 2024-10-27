import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? instance;
  String? dbName;
  int? dbVersion;
  Database? database;

  List<String> scripts = [];

  factory DbHelper({
    String? dbName,
    int? dbVersion,
    List<String> scripts = const [],
  }) {
    instance = DbHelper._privateConstructor(
      dbName: dbName,
      dbVersion: dbVersion,
      scripts: scripts,
    );

    return instance!;
  }

  DbHelper._privateConstructor({
    this.dbName,
    this.dbVersion,
    this.scripts = const [],
  });

  Future<Database?> get getDatabase async {
    if (database != null) {
      return database;
    }

    database = await initDatabase();

    return database;
  }

  Future<void> createDB(Database db, int newVersion) async {
    if (scripts.isNotEmpty) {
      for (String script in scripts) {
        await db.execute(script);
      }
    }
  }

  Future<Database> initDatabase() async {
    String dbPath = await getDatabasesPath();
    String db = dbName!;
    String fullPath = join(dbPath, db);

    return await openDatabase(
      fullPath,
      version: dbVersion,
      onCreate: createDB,
    );
  }
}
