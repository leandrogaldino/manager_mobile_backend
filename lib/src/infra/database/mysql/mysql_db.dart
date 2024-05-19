import 'package:backend/src/infra/database/database_result.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/shared/util/custom_env.dart';
import 'package:mysql1/mysql1.dart';

class MySqlDB extends MySql {
  MySqlConnection? _connection;

  @override
  Future<MySqlConnection> get connection async {
    _connection ??= await createConnection();
    return _connection!;
  }

  @override
  Future<MySqlConnection> createConnection() async => await MySqlConnection.connect(
        ConnectionSettings(
          host: await CustomEnv.get<String>(key: 'db_host'),
          port: await CustomEnv.get<int>(key: 'db_port'),
          user: await CustomEnv.get<String>(key: 'db_user'),
          password: await CustomEnv.get<String>(key: 'db_pass'),
          db: await CustomEnv.get<String>(key: 'db_schema'),
        ),
      );

  @override
  Future<DatabaseResult> execute(String sql, {List<Object?>? values}) async {
    var con = await connection;
    var result = await con.query(sql, values);
    List<Map<String, dynamic>> mapList = [];
    var fields = result.fields;
    for (var row in result) {
      var map = <String, dynamic>{};
      for (var i = 0; i < row.length; i++) {
        map[fields[i].name ?? ''] = row[i];
      }
      mapList.add(map);
    }
    return DatabaseResult(
      affectedRows: result.affectedRows ?? 0,
      lastInsertedRowId: result.insertId ?? 0,
      dataSet: mapList,
    );
  }
}
