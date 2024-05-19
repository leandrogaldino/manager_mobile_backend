import 'package:backend/src/apis/app_router.dart';
import 'package:shelf/shelf.dart';
import 'src/infra/custom_server.dart';
import 'src/infra/dependency_injector/inject.dart';
import 'src/infra/middleware_interception.dart';
import 'src/shared/util/custom_env.dart';

void main() async {
  CustomEnv.fromFile('.env');
  final di = Inject.initialize();
  var routes = di.get<AppRouter>().routes;
  var handler = Pipeline().addMiddleware(logRequests()).addMiddleware(MiddlewareInterception().contentTypeJson).addHandler(routes.call);
  await CustomServer().initialize(
    handler: handler,
    address: await CustomEnv.get<String>(key: 'server_address'),
    port: await CustomEnv.get<int>(key: 'server_port'),
  );
}
