import 'package:backend/src/apis/app_router.dart';
import 'package:backend/src/apis/compressor_api.dart';
import 'package:backend/src/apis/compressor_coalescent_api.dart';
import 'package:backend/src/apis/evaluation_api.dart';
import 'package:backend/src/dao/compressor_coalescent_dao.dart';
import 'package:backend/src/dao/compressor_dao.dart';
import 'package:backend/src/dao/evaluation_dao.dart';
import 'package:backend/src/dao/person_dao.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/infra/database/mysql/mysql_db.dart';
import 'package:backend/src/infra/storage/data_storage.dart';
import 'package:backend/src/services/compressor_coalescent_service.dart';
import 'package:backend/src/services/compressor_service.dart';
import 'package:backend/src/services/evaluation_service.dart';
import '../../apis/person_api.dart';
import '../../apis/auth_api.dart';
import '../../services/person_service.dart';
import '../security/security_service.dart';
import '../security/security_service_imp.dart';
import 'dependency_injector.dart';

class Inject {
  static DependencyInjector initialize() {
    var di = DependencyInjector();
    di.register<MySql>(() => MySqlDB());
    di.register<DataStorage>(() => DataStorage());
    di.register<SecurityService>(() => SecurityServiceImp());
    di.register<PersonDAO>(() => PersonDAO(di.get<MySql>()));
    di.register<PersonService>(() => PersonService(di.get<PersonDAO>()));
    di.register<PersonApi>(() => PersonApi(di.get<PersonService>()));
    di.register<CompressorDAO>(() => CompressorDAO(di.get<MySql>()));
    di.register<CompressorService>(() => CompressorService(di.get<CompressorDAO>()));
    di.register<CompressorApi>(() => CompressorApi(di.get<CompressorService>()));
    di.register<CompressorCoalescentDAO>(() => CompressorCoalescentDAO(di.get<MySql>()));
    di.register<CompressorCoalescentService>(() => CompressorCoalescentService(di.get<CompressorCoalescentDAO>()));
    di.register<CompressorCoalescentApi>(() => CompressorCoalescentApi(di.get<CompressorCoalescentService>()));

    di.register<EvaluationDAO>(() => EvaluationDAO(di.get<MySql>(), di.get<PersonDAO>(), di.get<CompressorDAO>(), di.get<DataStorage>()));
    di.register<EvaluationService>(() => EvaluationService(di.get<EvaluationDAO>()));
    di.register<EvaluationApi>(() => EvaluationApi(di.get<EvaluationService>(), di.get<PersonService>(), di.get<CompressorService>()));

    di.register<AuthApi>(() => AuthApi(di.get<SecurityService>(), di.get<PersonService>()));
    di.register<AppRouter>(
      () => AppRouter(
        di.get<AuthApi>(),
        di.get<PersonApi>(),
        di.get<CompressorApi>(),
        di.get<CompressorCoalescentApi>(),
        di.get<EvaluationApi>(),
      ),
    );
    return di;
  }
}
