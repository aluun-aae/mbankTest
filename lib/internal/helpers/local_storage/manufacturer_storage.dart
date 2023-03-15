import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../../features/manufacturers/data/models/makes_model.dart';
import '../../../features/manufacturers/data/models/manufacturer_model.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE manufacturers(
        Country TEXT,
        Mfr_CommonName TEXT,
        Mfr_ID INTEGER,
        Mfr_Name TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute(
        """CREATE TABLE makes(        
        Make_ID INTEGER,
        Make_Name TEXT,
        Model_ID INTEGER,
        Model_Name TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'example.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createMakesItem(MakesModel model) async {
    final db = await SQLHelper.db();

    final id = await db.insert(
      'makes',
      model.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> createManufacterItem(ManufacterModel model) async {
    final db = await SQLHelper.db();

    final id = await db.insert(
      'manufacturers',
      model.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<ManufacterModel>> getManufacterItems() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('manufacturers', orderBy: "Mfr_ID");
    return List.generate(
      maps.length,
      (i) {
        return ManufacterModel(
          country: maps[i]["Country"],
          mfrCommonName: maps[i]['Mfr_CommonName'],
          mfrId: maps[i]['Mfr_ID'],
          mfrName: maps[i]['Mfr_Name'],
        );
      },
    );
  }

  static Future<List<MakesModel>> getMakesItems(String makeName) async {
    final db = await SQLHelper.db();
    log(makeName);
    final List<Map<String, dynamic>> maps = await db.query('makes',
        where: "Make_Name = ?", orderBy: "Make_ID", whereArgs: [makeName]);
    return List.generate(
      maps.length,
      (i) {
        return MakesModel(
          makeId: maps[i]["Make_ID"],
          makeName: maps[i]['Make_Name'],
          modelId: maps[i]['Model_ID'],
          modelName: maps[i]['Model_Name'],
        );
      },
    );
  }

  // Update an item by id
  static Future<int> updateItem(int id, int mfrId, String? descrption,
      String? country, String? commonName, String? name) async {
    final db = await SQLHelper.db();

    final data = {
      'mfr_id': mfrId,
      'country': country,
      "mfr_commonName": commonName,
      "mfr_name": name,
      'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('manufacturers', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteManufacturerItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        "manufacturers",
        // Use a `where` clause to delete a specific dog.
        where: 'Mfr_ID = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  } // Delete

  static Future<void> deleteMakesItem(String modelName) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(
        "makes",
        where: 'Model_Name = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [modelName],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
