import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/occurrence.dart';
import '../utils/constants.dart';
import '../utils/database.dart';

class OccurrenceHelper with ChangeNotifier {
  List<Occurrence> _occurrences = [];

  List<Occurrence> get occurrences {
    return [..._occurrences];
  }

  Future<void> createOccurrence(Occurrence occurrence) async {
    final sql.Database db = await Database.instance;
    final id = await db.insert(
      Constants.tableOccurrences,
      occurrence.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    occurrence.id = id;
    _occurrences.add(occurrence);
    notifyListeners();
  }

  Future<List<Occurrence>> getAllOccurrencies() async {
    final dataList = await Database.getData(Constants.tableOccurrences);
    _occurrences =
        dataList.map((occurrence) => Occurrence.fromJson(occurrence)).toList();
    _occurrences.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
    return _occurrences;
  }

  static Future<Occurrence> getOccurrence(int id) async {
    List<String> colunas = [
      'id',
      'title',
      'date',
      'wrapProjectionId',
      'forwardProjectionId',
    ];
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    final dataList = await Database.getDataWhere(
        Constants.tableOccurrences, colunas, whereString, whereArgument);
    return Occurrence.fromJson(dataList.first);
  }

  void updateOccurrence(int id, Occurrence occurrence) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.editData(Constants.tableOccurrences, occurrence.toJson(),
        whereString, whereArgument);
  }

  void deleteOccurrence(int id) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.deleteData(Constants.tableOccurrences, whereString, whereArgument);
  }
}
