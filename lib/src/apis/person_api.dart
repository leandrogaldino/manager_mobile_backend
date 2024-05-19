import 'dart:convert';
import 'package:backend/src/apis/api.dart';
import 'package:backend/src/shared/util/messages.dart';
import 'package:backend/src/models/person_model.dart';
import 'package:backend/src/services/person_service.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PersonApi extends Api {
  final PersonService _service;

  PersonApi(this._service);

  ///Retorna o handler responsável pelas rotas da API da pessoa.
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    /// Salva ou atualiza uma pessoa.
    router.post('/person', (Request req) async {
      try {
        String body = await req.readAsString();
        String? invalidBodyMessage = validateRequestBody(body);
        bool toInsert = isNew(body);
        if (invalidBodyMessage != null) return Response.badRequest(body: invalidBodyMessage);
        PersonModel model = PersonModel.fromJson(body);
        int personId = await _service.save(model).then((value) => value.id);
        return Response.ok(toInsert ? '${Messages.saveSuccess}  Id: $personId.' : Messages.updateSuccess);
      } on ValidationException catch (e) {
        return Response.badRequest(body: e.message);
      } catch (e) {
        return Response.internalServerError(body: '${Messages.saveError} [$e]');
      }
    });

    /// Busca todas as pessoas cadastradas.
    router.get('/persons', (Request req) async {
      try {
        List<PersonModel> listModel = await _service.getAll();
        List<Map> listMap = listModel.map((e) => e.toMap()).toList();
        return Response.ok(jsonEncode(listMap));
      } catch (e) {
        return Response.internalServerError(body: '${Messages.fetchError} [$e]');
      }
    });

    ///Busca uma pessoa pelo seu id.
    router.get('/person', (Request req) async {
      String? id = req.url.queryParameters['id'];
      try {
        if (id == null) return Response.badRequest(body: Messages.missingId);
        var model = await _service.getById(int.parse(id));
        if (model != null) {
          return Response.ok(jsonEncode(model.toMap()));
        } else {
          return Response.notFound(Messages.recordNotFound);
        }
      } catch (e) {
        return Response.internalServerError(body: '${Messages.fetchError} [$e]');
      }
    });

    ///Deleta uma pessoa pelo seu id.
    router.delete('/person', (Request req) async {
      String? id = req.url.queryParameters['id'];
      try {
        if (id == null) return Response.badRequest(body: Messages.missingId);
        var result = await _service.delete(int.parse(id));
        return result ? Response.ok(Messages.deleteSuccess) : Response.internalServerError(body: Messages.dataNotFound);
      } catch (e) {
        return Response.internalServerError(body: '${Messages.deleteError} [$e]');
      }
    });

    return createHandler(router: router.call, middlewares: middlewares, isSecurity: isSecurity);
  }

  /// Valida o corpo de uma requisição.
  ///
  /// Retorna uma mensagem de erro se o corpo da requisição não atender aos critérios de formato e conteúdo.
  /// Caso contrário, retorna null.
  String? validateRequestBody(String body) {
    if (body.isEmpty) return 'O JSON não foi fornecido na requisição.';
    if (!isAJson(body)) return 'JSON inválido. Por favor, verifique a formatação.';
    if (!containsField(body, 'id', int)) return 'O campo id, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'document', String)) return 'O campo document, do tipo string, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'name', String)) return 'O campo name, do tipo string, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'istechnician', bool)) return 'O campo istechnician, do boolean lista, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'iscustomer', bool)) return 'O campo iscustomer, do tipo boolean, não está presente. Por favor, inclua-o na sua requisição.';
    return null;
  }
}
