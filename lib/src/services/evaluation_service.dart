import 'package:backend/src/dao/evaluation_dao.dart';
import 'package:backend/src/models/evaluation_model.dart';
import 'package:backend/src/services/service.dart';
import 'package:backend/src/services/service_get_by_date.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';

class EvaluationService implements Service<EvaluationModel>, ServiceGetByDate<EvaluationModel> {
  final EvaluationDAO _dao;

  EvaluationService(this._dao);
  @override
  Future<bool> delete(int id) async {
    return await _dao.delete(id);
  }

  @override
  Future<EvaluationModel?> getById(int id) async {
    return await _dao.getById(id);
  }

  @override
  Future<EvaluationModel> save(EvaluationModel value) async {
    String? invalidMessage = validate(value);
    if (invalidMessage == null) {
      if (value.id <= 0) {
        return await _dao.create(value);
      } else {
        return await _dao.update(value);
      }
    } else {
      throw ValidationException(invalidMessage);
    }
  }

  @override
  Future<List<EvaluationModel>> getByDate(DateTime start, DateTime end) async {
    return await _dao.getByDate(start, end);
  }

  String? validate(EvaluationModel value) {
    if (value.customer.id <= 0) return 'O cliente utilizado nessa avaliação está sem id.';
    if (value.compressor.id <= 0) return 'O compressor utilizado nessa avaliação está sem id.';
    if (value.responsible.isEmpty) return 'O responsável deve ser informado.';
    if (value.horimeter < 0) return 'A leitura do horímetro não pode ser negativa.';
    if (value.airFilter < 0) return 'A leitura do filtro de ar não pode ser negativa.';
    if (value.oilFilter < 0) return 'A leitura do filtro de ar não pode ser negativa.';
    if (value.separator < 0) return 'A leitura do filtro de ar não pode ser negativa.';
    if (value.oilType < 0) return 'O tipo de óleo não pode ser menor que 0.';
    if (value.oilType > 2) return 'O tipo de óleo não pode ser maior que 2.';
    if (value.oil < 0) return 'A leitura do óleo não pode ser negativa.';
    if (value.oilType == 0 && value.oil > 1000) return 'A leitura do óleo não pode ser maior que 1000.';
    if (value.oilType == 1 && value.oil > 4000) return 'A leitura do óleo não pode ser maior que 4000.';
    if (value.oilType == 2 && value.oil > 8000) return 'A leitura do óleo não pode ser maior que 8000.';
    if (value.technicians.any((technician) => technician.personid == 0)) 'Não é possível salvar um técnico com id da pessoa = 0.';
    return null;
  }
}
