import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/src/services/person_service.dart';
import '../infra/security/security_service.dart';
import 'api.dart';

class AuthApi extends Api {
  final SecurityService _securityService;
  final PersonService _personService;
  AuthApi(this._securityService, this._personService);
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();
    router.post('/auth', (Request req) async {
      try {
        var body = await req.readAsString();
        if (body.isEmpty) {
          return Response.badRequest(body: 'Corpo da requisição vazio.');
        }
        late Map<String, dynamic> decodedJson;
        try {
          decodedJson = jsonDecode(body);
        } on FormatException {
          return Response.badRequest(body: 'Formato JSON inválido.');
        }
        if (decodedJson['accesscode'] == null) {
          return Response.badRequest(body: 'Campo "accesscode" ausente no JSON.');
        }
        var code = decodedJson['accesscode'];
        var userId = await _personService.getIdByCode(code);
        if (userId == null) {
          return Response.unauthorized('Falha na autenticação: Código de acesso inválido.');
        }
        var token = await _securityService.generateJWT(userId.toString());
        return Response.ok(jsonEncode({'personid': userId, 'bearertoken': token}));
      } catch (e) {
        return Response.internalServerError(body: 'Erro interno durante autenticação: [$e]');
      }
    });
    return createHandler(router: router.call, middlewares: middlewares);
  }
}
