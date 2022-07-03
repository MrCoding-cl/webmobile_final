import 'package:notesapp/sqlite/model/nota.dart';
import 'package:notesapp/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDelete {
  Future<void> nota(Nota nota) async {
    final Database db = await SQLiteHelper.getDB();
    await db.delete("notas", where: "id = ?", whereArgs: [nota.id]);
  }
}
