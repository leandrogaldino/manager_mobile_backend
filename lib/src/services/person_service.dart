import 'package:backend/src/dao/person_dao.dart';
import 'package:backend/src/models/person_model.dart';
import 'package:backend/src/services/service_get_all.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'service.dart';

class PersonService implements Service<PersonModel>, ServiceGetAll<PersonModel> {
  final PersonDAO _dao;

  PersonService(this._dao);

  @override
  Future<bool> delete(int id) async {
    return await _dao.delete(id);
  }

  @override
  Future<List<PersonModel>> getAll() async {
    return await _dao.getAll();
  }

  @override
  Future<PersonModel?> getById(int id) async {
    return await _dao.getById(id);
  }

  @override
  Future<PersonModel> save(PersonModel value) async {
    String? invalidMessage = validate(value);
    if (invalidMessage == null) {
      PersonModel? model = await _dao.getById(value.id);
      if (model == null) {
        return await _dao.create(value);
      } else {
        return await _dao.update(value);
      }
    } else {
      throw ValidationException(invalidMessage);
    }
  }

  Future<int?> getIdByCode(String accessCode) async {
    return await _dao.getIdByCode(accessCode);
  }

  String? validate(PersonModel value) {
    if (value.document.isEmpty) return 'Não é possível salvar uma pessoa sem documento';
    if (value.name.isEmpty) return 'Não é possível salvar uma pessoa sem nome.';
    return null;
  }
}
