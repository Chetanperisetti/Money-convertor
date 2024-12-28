import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  //intialize the database
  static Future<Database> initDB() async {
    final databasepath = await getDatabasesPath();
    final path = join(databasepath, "money.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
              CREATE TABLE conversions(
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             input TEXT,
             result TEXT)
            ''');
      },
    );
  }

  //get the database instance
  static Future<Database> getDatabase() async {
    _database ??= await initDB();
    return _database!;
  }

  // insert the data
  static Future<void> insertData(String input, String result) async {
    final db = await getDatabase();
    await db.insert('conversions', {'input': input, 'result': result});
  }

  //get all the data
  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await getDatabase();
    return await db.query('conversions', orderBy: 'DESC');
  }

  //clear the data
  static Future<void> clearData() async {
    final db = await getDatabase();
    await db.delete('conversions');
  }
}
