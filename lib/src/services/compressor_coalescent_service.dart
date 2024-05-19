import 'package:backend/src/dao/compressor_coalescent_dao.dart';
import 'package:backend/src/models/compressor_coalescent_model.dart';
import 'package:backend/src/services/service_get_by_parent.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'service.dart';

class CompressorCoalescentService implements Service<CompressorCoalescentModel>, ServiceGetByParent<CompressorCoalescentModel> {
  final CompressorCoalescentDAO _dao;

  CompressorCoalescentService(this._dao);

  @override
  Future<bool> delete(int id) async {
    return await _dao.delete(id);
  }

  @override
  Future<CompressorCoalescentModel?> getById(int id) async {
    return await _dao.getById(id);
  }

  @override
  Future<CompressorCoalescentModel> save(CompressorCoalescentModel value) async {
    String? invalidMessage = validate(value);
    if (invalidMessage == null) {
      CompressorCoalescentModel? model = await _dao.getById(value.id);
      if (model == null) {
        return await _dao.create(value);
      } else {
        return await _dao.update(value);
      }
    } else {
      throw ValidationException(invalidMessage);
    }
  }

  @override
  Future<List<CompressorCoalescentModel>> getByParentId(int compressorId) async {
    return await _dao.getByParentId(compressorId);
  }

  String? validate(CompressorCoalescentModel value) {
    if (value.name.isEmpty) return 'Não é possível salvar uma pessoa sem nome.';
    return null;
  }
}
