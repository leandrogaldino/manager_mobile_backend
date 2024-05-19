import 'package:backend/src/dao/dao.dart';
import 'package:backend/src/dao/dao_get_by_parent.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/infra/database/sql/compressor_coalescent_sql.dart';
import 'package:backend/src/models/compressor_coalescent_model.dart';

class CompressorCoalescentDAO implements DAO<CompressorCoalescentModel>, GetByParentDAO<CompressorCoalescentModel> {
  final MySql _db;
  CompressorCoalescentDAO(
    this._db,
  );
  @override
  Future<CompressorCoalescentModel> create(CompressorCoalescentModel value) async {
    await _db.execute(
      CompressorCoalescentSQL.insert,
      values: [
        value.id,
        value.compressorId,
        value.name,
      ],
    );
    return value;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _db.execute(CompressorCoalescentSQL.delete, values: [id]);
    if (result.affectedRows == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<CompressorCoalescentModel?> getById(int id) async {
    var listMap = await _db.execute(CompressorCoalescentSQL.getById, values: [id]).then((value) => value.dataSet);
    if (listMap != null && listMap.length == 1) {
      return CompressorCoalescentModel.fromMap(listMap.first);
    }
    return null;
  }

  @override
  Future<CompressorCoalescentModel> update(CompressorCoalescentModel value) async {
    await _db.execute(
      CompressorCoalescentSQL.update,
      values: [
        value.name,
        value.id,
      ],
    );
    return value;
  }

  @override
  Future<List<CompressorCoalescentModel>> getByParentId(int compressorId) async {
    var listMap = await _db.execute(CompressorCoalescentSQL.getByCompressorId, values: [compressorId]).then((value) => value.dataSet);
    if (listMap == null) return [];
    var listModel = listMap.map((map) => CompressorCoalescentModel.fromMap(map)).toList();
    return listModel;
  }
}
