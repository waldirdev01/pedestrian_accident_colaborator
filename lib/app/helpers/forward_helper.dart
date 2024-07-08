import 'package:sqflite/sqflite.dart' as sql;

import '../models/forward_projection.dart';
import '../models/occurrence.dart';
import '../utils/constants.dart';
import '../utils/database.dart';

class ForwardHelper {
  Future<void> addForwardProjection(
      ForwardProjection forwardProjection, Occurrence occurrence) async {
    final sql.Database db = await Database.instance;
    final id = await db.insert(
      Constants.tableForwardProjection,
      forwardProjection.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    forwardProjection.id = id;
    occurrence.forwardProjectionId = id;
    Database.editData(Constants.tableOccurrences, occurrence.toJson(), 'id = ?',
        [occurrence.id]);
  }

  Future<List<ForwardProjection>> getAllForwardProjetion() async {
    final dataList = await Database.getData(Constants.tableForwardProjection);
    return dataList
        .map((forwardProjection) =>
            ForwardProjection.fromJson(forwardProjection))
        .toList();
  }

  static Future<ForwardProjection> getForwardProjection(int id) async {
    List<String> colunas = [
      'id',
      'pedestrianCGHeight',
      'pedestrianMass',
      'pedestrianFrictionCoefficientMin',
      'pedestrianFrictionCoefficientMax',
      'vehicleFrictionCoefficientMin',
      'vehicleFrictionCoefficientMax',
      'pedestrianProjectionSpeedMin',
      'pedestrianProjectionSpeedMax',
      'pedestrianProjectionDistance',
      'slidingDistance',
      'vehicleMass',
      'vehicleSpeedNortwesternMin',
      'vehicleSpeedNortwesternMax',
      'toorSpeed'
    ];
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    final dataList = await Database.getDataWhere(
        Constants.tableForwardProjection, colunas, whereString, whereArgument);
    return ForwardProjection.fromJson(dataList.first);
  }

  void updateForwardProjection(int id, ForwardProjection forwardProjection) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.editData(Constants.tableForwardProjection,
        forwardProjection.toJson(), whereString, whereArgument);
  }

  void deleteForwardProjection(int id) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.deleteData(
        Constants.tableForwardProjection, whereString, whereArgument);
  }
}
