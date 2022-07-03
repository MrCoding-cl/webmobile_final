import 'package:flutter/material.dart';
import 'package:notesapp/sqlite/model/nota.dart';
import 'package:notesapp/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQliteQuery with ChangeNotifier {
  List<Nota>? _notas;

  List<Nota> get nota => [...?_notas];

  Future<void> updateNotas() async {
    final Database db = await SQLiteHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query('notas');

    _notas = List.generate(maps.length, (i) {
      return Nota(
        id: maps[i]['id'],
        titulo: maps[i]['titulo'],
        descripcion: maps[i]['descripcion'],
      );
    });

    notifyListeners();
  }
}
