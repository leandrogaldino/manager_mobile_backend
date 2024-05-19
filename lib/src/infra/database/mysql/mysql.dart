import 'package:backend/src/infra/database/database.dart';
import 'package:backend/src/infra/database/database_result.dart';
import 'package:mysql1/mysql1.dart';

abstract class MySql implements Database<MySqlConnection> {
  Future<DatabaseResult> execute(String sql, {List<Object?>? values});
  Future<DatabaseResult> startTransaction() async {
    var con = await connection;
    await con.query('START TRANSACTION');
    return DatabaseResult(affectedRows: 0);
  }

  Future<DatabaseResult> commitTransaction() async {
    var con = await connection;
    await con.query('COMMIT');
    return DatabaseResult(affectedRows: 0);
  }

  Future<DatabaseResult> rollbackTransaction() async {
    var con = await connection;
    await con.query('ROLLBACK');
    return DatabaseResult(affectedRows: 0);
  }
}
