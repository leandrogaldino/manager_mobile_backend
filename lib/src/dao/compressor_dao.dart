import 'package:backend/src/dao/dao.dart';
import 'package:backend/src/dao/dao_get_by_parent.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/infra/database/sql/compressor_coalescent_sql.dart';
import 'package:backend/src/infra/database/sql/compressor_sql.dart';
import 'package:backend/src/models/compressor_coalescent_model.dart';
import 'package:backend/src/models/compressor_model.dart';

class CompressorDAO implements DAO<CompressorModel>, GetByParentDAO<CompressorModel> {
  final MySql _db;
  CompressorDAO(
    this._db,
  );
  @override
  Future<CompressorModel> create(CompressorModel value) async {
    try {
      await _db.startTransaction();
      await _db.execute(
        CompressorSQL.insert,
        values: [
          value.id,
          value.personId,
          value.name,
        ],
      );
      for (var coalescent in value.coalescents) {
        await _db.execute(
          CompressorCoalescentSQL.insert,
          values: [
            coalescent.id,
            coalescent.compressorId,
            coalescent.name,
          ],
        );
      }
      _db.commitTransaction();
      return value;
    } catch (e) {
      _db.rollbackTransaction();
      rethrow;
    }
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _db.execute(CompressorSQL.delete, values: [id]);
    if (result.affectedRows == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<CompressorModel?> getById(int id) async {
    var compressorListMap = await _db.execute(CompressorSQL.getById, values: [id]).then((value) => value.dataSet);
    if (compressorListMap != null && compressorListMap.length == 1) {
      var coalescentsMap = await _db.execute(CompressorCoalescentSQL.getByCompressorId, values: [compressorListMap.first['id']]).then((value) => value.dataSet);
      var coalescents = coalescentsMap?.map((e) => CompressorCoalescentModel.fromMap(e)).toList() ?? [];
      return CompressorModel.create(compressorListMap.first, coalescents);
    }
    return null;
  }

  @override
  Future<List<CompressorModel>> getByParentId(int personId) async {
    final compressorsMap = await _db.execute(CompressorSQL.getByPersonId, values: [personId]).then((value) => value.dataSet);
    if (compressorsMap != null && compressorsMap.isNotEmpty) {
      List<CompressorModel> compressors = [];
      for (var compressorMap in compressorsMap) {
        var coalescentsMap = await _db.execute(CompressorCoalescentSQL.getByCompressorId, values: [compressorMap['id']]).then((value) => value.dataSet);
        var coalescents = coalescentsMap?.map((e) => CompressorCoalescentModel.fromMap(e)).toList() ?? [];
        var compressor = CompressorModel.create(compressorMap, coalescents);
        compressors.add(compressor);
      }
      return compressors;
    }
    return [];
  }

  Future<void> _updateCoalescents(CompressorModel compressor) async {
    var dbCoalescentsMap = await _db.execute(CompressorCoalescentSQL.getByCompressorId, values: [compressor.id]).then((value) => value.dataSet);
    dbCoalescentsMap ??= [];
    var dbCoalescentsModel = dbCoalescentsMap.map((e) => CompressorCoalescentModel.fromMap(e)).toList();
    List<CompressorCoalescentModel> coalescentsToSave = compressor.coalescents.where((coalescent) => !dbCoalescentsModel.any((dbCoalescent) => dbCoalescent.id == coalescent.id)).toList();
    List<CompressorCoalescentModel> coalescentsToDelete = dbCoalescentsModel.where((dbCoalescent) => !compressor.coalescents.any((coalescent) => coalescent.id == dbCoalescent.id)).toList();
    List<CompressorCoalescentModel> coalescentsToUpdate = compressor.coalescents.where((coalescent) => dbCoalescentsModel.any((dbCoalescent) => dbCoalescent.id == coalescent.id)).toList();
    for (var coalescent in coalescentsToSave) {
      await _db.execute(
        CompressorCoalescentSQL.insert,
        values: [
          coalescent.id,
          compressor.id,
          coalescent.name,
        ],
      );
    }
    for (var coalescent in coalescentsToDelete) {
      await _db.execute(
        CompressorCoalescentSQL.delete,
        values: [
          coalescent.id,
        ],
      );
    }
    for (var coalescent in coalescentsToUpdate) {
      await _db.execute(
        CompressorCoalescentSQL.update,
        values: [
          coalescent.name,
          coalescent.id,
        ],
      );
    }
  }

  @override
  Future<CompressorModel> update(CompressorModel value) async {
    try {
      await _db.startTransaction();
      await _db.execute(
        CompressorSQL.update,
        values: [
          value.name,
          value.id,
        ],
      );
      await _updateCoalescents(value);
      await _db.commitTransaction();
      return value;
    } catch (e) {
      await _db.rollbackTransaction();
      rethrow;
    }
  }
}
