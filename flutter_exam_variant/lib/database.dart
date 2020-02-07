import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseProvider {
  Future<Database> getDatabase() async {
    return openDatabase(
        join(await getDatabasesPath(), "models.db"),
        onCreate: (db, version) async {
          await db.execute(
              "CREATE TABLE models(id INTEGER PRIMARY KEY , model TEXT , status TEXT , client INTEGER , time INTEGER , cost INTEGER)"
          );
        },
        version: 1
    );
  }

  Future<List<Model>> getModels() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("models");
    return List.generate(maps.length, (i) {
      return Model(
          id: maps[i]["id"],
          model: maps[i]["model"],
          status: maps[i]["status"],
          client: maps[i]["client"],
          time: maps[i]["time"],
          cost: maps[i]["cost"]
      );
    });
  }

  Future<List<Model>> getModelsForClient(int clientId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
        "models",
        where: "client = ?",
        whereArgs: [clientId]
    );
    return List.generate(maps.length, (i) {
      return Model(
          id: maps[i]["id"],
          model: maps[i]["model"],
          status: maps[i]["status"],
          client: maps[i]["client"],
          time: maps[i]["time"],
          cost: maps[i]["cost"]
      );
    });
  }

  Future<int> insertModel(Model model) async {
    final Database db = await getDatabase();
    var id = await db.insert(
        "models",
        model.toMapNoId(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id.toInt();
  }

  Future<void> updateModel(Model model) async {
    final Database db = await getDatabase();
    await db.update(
        "models",
        model.toMap(),
        where: "id = ?",
        whereArgs: [model.id]
    );
  }

  Future<void> deleteModel(int id) async {
    final Database db = await getDatabase();
    await db.delete(
        "models",
        where: "id = ?",
        whereArgs: [id]
    );
  }
}