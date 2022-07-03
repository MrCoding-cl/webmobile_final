import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static Future<Database>? _database;

  static Future<Database> getDB() async {
    if (_database == null) {
      return _initDB();
    } else {
      return _database!;
    }
  }

  static Future<Database> _initDB() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'notas.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE notas (id INTEGER PRIMARY KEY, titulo TEXT NOT NULL, descripcion TEXT)');
      },
    );
    return db;
  }
}
