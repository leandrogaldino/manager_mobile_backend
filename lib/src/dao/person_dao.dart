import 'package:backend/src/dao/dao.dart';
import 'package:backend/src/dao/dao_get_all.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/infra/database/sql/person_sql.dart';
import 'package:backend/src/models/person_model.dart';

class PersonDAO implements DAO<PersonModel>, GetAllDAO<PersonModel> {
  final MySql _db;
  PersonDAO(
    this._db,
  );
  @override
  Future<PersonModel> create(PersonModel value) async {
    await _db.execute(
      PersonSQL.insert,
      values: [
        value.id,
        value.document,
        value.name,
        value.isTechnician,
        value.isCustomer,
      ],
    );
    return value;
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _db.execute(PersonSQL.delete, values: [id]);
    if (result.affectedRows == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<PersonModel>> getAll() async {
    var persons = await _db.execute(PersonSQL.getAll).then((value) => value.dataSet);
    if (persons == null) return [];
    var personsList = persons.map((map) => PersonModel.fromMap(map)).toList();
    return personsList;
  }

  @override
  Future<PersonModel?> getById(int id) async {
    var personListMap = await _db.execute(PersonSQL.getById, values: [id]).then((value) => value.dataSet);
    if (personListMap != null && personListMap.length == 1) {
      return PersonModel.fromMap(personListMap.first);
    }
    return null;
  }

  @override
  Future<PersonModel> update(PersonModel value) async {
    await _db.execute(
      PersonSQL.update,
      values: [
        value.document,
        value.name,
        value.isTechnician,
        value.isCustomer,
        value.id,
      ],
    );
    return value;
  }

  Future<int?> getIdByCode(String accessCode) async {
    int? id = await _db.execute(PersonSQL.getIdByCode, values: [accessCode]).then(
      (value) {
        if (value.dataSet != null && value.dataSet!.length == 1) return value.dataSet!.first['id'];
        return null;
      },
    );
    return id;
  }
}
