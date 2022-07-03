import 'package:notesapp/sqlite/model/nota.dart';
import 'package:notesapp/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteInsert {
  Future<void> nota(Nota nota) async {
    final Database db = await SQLiteHelper.getDB();

    await db.insert("notas", nota.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
