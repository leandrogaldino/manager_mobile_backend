import 'package:backend/src/dao/compressor_dao.dart';
import 'package:backend/src/models/compressor_model.dart';
import 'package:backend/src/services/service_get_by_parent.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'service.dart';

class CompressorService implements Service<CompressorModel>, ServiceGetByParent<CompressorModel> {
  final CompressorDAO _dao;

  CompressorService(this._dao);

  @override
  Future<bool> delete(int id) async {
    return await _dao.delete(id);
  }

  @override
  Future<List<CompressorModel>> getByParentId(int personId) async {
    return await _dao.getByParentId(personId);
  }

  @override
  Future<CompressorModel?> getById(int id) async {
    return await _dao.getById(id);
  }

  @override
  Future<CompressorModel> save(CompressorModel value) async {
    String? invalidMessage = validate(value);
    if (invalidMessage == null) {
      CompressorModel? model = await _dao.getById(value.id);
      if (model == null) {
        return await _dao.create(value);
      } else {
        return await _dao.update(value);
      }
    } else {
      throw ValidationException(invalidMessage);
    }
  }

  String? validate(CompressorModel value) {
    if (value.name.isEmpty) return 'Não é possível salvar um compressor sem nome.';
    if (value.coalescents.any((coalescent) => coalescent.id == 0)) 'Não é possível salvar um coalescente com id = 0.';
    if (value.coalescents.map((coalescent) => coalescent.id).toSet().length != value.coalescents.length) return 'Não é possível salvar um compressor com coalescentes que possuem IDs duplicados';
    if (value.coalescents.any((coalescent) => coalescent.name.isEmpty)) return 'Não é possível salvar um coalescente sem nome.';
    return null;
  }
}
