import 'package:sqflite/sqflite.dart' as sql;

import 'constants.dart';

class Database {
  static const version = 1;

  static Future _onConfigure(sql.Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Database._();
  static sql.Database? _database;

  static Future<sql.Database> get instance async {
    if (_database != null) {
      return _database!;
    }
    _database = await _init();
    return _database!;
  }

  static Future<sql.Database> _init() async {
    return await sql.openDatabase(
      Constants.databaseName,
      version: version,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(sql.Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.tableOccurrences} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        wrapProjectionId INTEGER,
        forwardProjectionId INTEGER,
        FOREIGN KEY (wrapProjectionId) REFERENCES wrapProjection(id),
        FOREIGN KEY (forwardProjectionId) REFERENCES forwardProjection(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${Constants.tableWrapProjection} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pedestrianHeightCG REAL NOT NULL,
        pedestrianFrictionCoefficientMin REAL NOT NULL,
        pedestrianFrictionCoefficientMax REAL NOT NULL,  
        pedestrianProjectionSpeedMin REAL NOT NULL,
        pedestrianProjectionSpeedMax REAL NOT NULL,
        pedestrianProjectionDistance REAL NOT NULL,
        vehicleHeightFront REAL NOT NULL,
        vehicleFrictionCoefficientMin REAL NOT NULL,
        vehicleFrictionCoefficientMax REAL NOT NULL,
        vehicleSpeedSearleMin REAL NOT NULL,
        vehicleSpeedSearleMax REAL NOT NULL,
        vehicleSpeedLimpertMin REAL NOT NULL,
        vehicleSpeedLimpertMax REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${Constants.tableForwardProjection} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pedestrianCGHeight REAL NOT NULL,
        pedestrianMass REAL NOT NULL,
        pedestrianFrictionCoefficientMin REAL NOT NULL,
        pedestrianFrictionCoefficientMax REAL NOT NULL,
        vehicleFrictionCoefficientMin REAL NOT NULL,
        vehicleFrictionCoefficientMax REAL NOT NULL,
        pedestrianProjectionSpeedMin REAL NOT NULL,
        pedestrianProjectionSpeedMax REAL NOT NULL,
        pedestrianProjectionDistance REAL NOT NULL,
        slidingDistance REAL NOT NULL,
        vehicleMass REAL NOT NULL,
        vehicleSpeedNortwesternMin REAL NOT NULL,
        vehicleSpeedNortwesternMax REAL NOT NULL,
        toorSpeed REAL NOT NULL
      )
    ''');
  }

  static Future<void> insertData(
      String table, Map<String, dynamic> dados) async {
    final db = await _init();
    await db.insert(table, dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await _init();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getDataWhere(
      String table,
      List<String> colunas,
      String whereString,
      List<dynamic> whereArgument) async {
    final db = await _init();
    return db.query(
      table,
      columns: colunas,
      where: whereString,
      whereArgs: whereArgument,
    );
  }

  static Future<void> editData(String table, Map<String, dynamic> dados,
      String whereString, List<dynamic> whereArgument) async {
    final db = await _init();
    await db.update(table, dados, where: whereString, whereArgs: whereArgument);
  }

  static Future<void> deleteData(
      String table, String whereString, List<dynamic> whereArgument) async {
    final db = await _init();
    await db.delete(table, where: whereString, whereArgs: whereArgument);
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
