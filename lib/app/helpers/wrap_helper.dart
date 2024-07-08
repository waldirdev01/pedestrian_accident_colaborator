import 'package:sqflite/sqflite.dart' as sql;

import '../models/occurrence.dart';
import '../models/wrap_projection.dart';
import '../utils/constants.dart';
import '../utils/database.dart';

class WrapHelper {
  Future<void> addWrapProjection(
      WrapProjection wrapProjection, Occurrence occurrence) async {
    final sql.Database db = await Database.instance;
    final id = await db.insert(
      Constants.tableWrapProjection,
      wrapProjection.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    wrapProjection.id = id;
    occurrence.wrapProjectionId = id;
    Database.editData(Constants.tableOccurrences, occurrence.toJson(), 'id = ?',
        [occurrence.id]);
  }

  Future<List<WrapProjection>> getAllWrapProjection() async {
    final dataList = await Database.getData(Constants.tableWrapProjection);
    return dataList
        .map((wrapProjection) => WrapProjection.fromJson(wrapProjection))
        .toList();
  }

  static Future<WrapProjection> getWrpaProjection(int id) async {
    List<String> colunas = [
      'id',
      'pedestrianHeightCG',
      'pedestrianFrictionCoefficientMin',
      'pedestrianFrictionCoefficientMax',
      'pedestrianProjectionSpeedMin',
      'pedestrianProjectionSpeedMax',
      'pedestrianProjectionDistance',
      'vehicleHeightFront',
      'vehicleFrictionCoefficientMin',
      'vehicleFrictionCoefficientMax',
      'vehicleSpeedSearleMin',
      'vehicleSpeedSearleMax',
      'vehicleSpeedLimpertMin',
      'vehicleSpeedLimpertMax'
    ];
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    final dataList = await Database.getDataWhere(
        Constants.tableWrapProjection, colunas, whereString, whereArgument);
    return WrapProjection.fromJson(dataList.first);
  }

  void updateWrapProjection(int id, WrapProjection wrapProjection) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.editData(Constants.tableWrapProjection, wrapProjection.toJson(),
        whereString, whereArgument);
  }

  void deleteWrapProjection(int id) {
    String whereString = 'id = ?';
    List<dynamic> whereArgument = [id];
    Database.deleteData(
        Constants.tableWrapProjection, whereString, whereArgument);
  }
}
