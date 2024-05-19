import 'dart:convert';
import 'package:backend/src/apis/api.dart';
import 'package:backend/src/models/compressor_coalescent_model.dart';
import 'package:backend/src/services/compressor_coalescent_service.dart';
import 'package:backend/src/shared/util/messages.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class CompressorCoalescentApi extends Api {
  final CompressorCoalescentService _service;

  CompressorCoalescentApi(this._service);

  ///Retorna o handler responsável pelas rotas da API do coalescente de compressor.
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    /// Salva ou atualiza um coalescente de compressor.
    router.post('/compressorcoalescent', (Request req) async {
      try {
        String body = await req.readAsString();
        String? invalidBodyMessage = validateRequestBody(body);
        bool toInsert = isNew(body);
        if (invalidBodyMessage != null) return Response.badRequest(body: invalidBodyMessage);
        CompressorCoalescentModel model = CompressorCoalescentModel.fromJson(body);
        int coalescentId = await _service.save(model).then((value) => value.id);
        return Response.ok(toInsert ? '${Messages.saveSuccess}  Id: $coalescentId.' : Messages.updateSuccess);
      } on ValidationException catch (e) {
        return Response.badRequest(body: e.message);
      } catch (e) {
        return Response.internalServerError(body: '${Messages.saveError} [$e]');
      }
    });

    /// Busca todos os coalescentes de compressor pelo id do compressor.
    router.get('/compressorcoalescents', (Request req) async {
      String? id = req.url.queryParameters['compressorid'];
      try {
        if (id == null) return Response.badRequest(body: Messages.missingParentId);
        List<CompressorCoalescentModel> listModel = await _service.getByParentId(int.parse(id));
        List<Map> listMap = listModel.map((e) => e.toMap()).toList();
        return Response.ok(jsonEncode(listMap));
      } catch (e) {
        return Response.internalServerError(body: '${Messages.fetchError} [$e]');
      }
    });

    ///Busca um coalescente de compressor pelo seu id.
    router.get('/compressorcoalescent', (Request req) async {
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

    ///Deleta um coalescente de compressor pelo seu id.
    router.delete('/compressorcoalescent', (Request req) async {
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
    if (!containsField(body, 'compressorid', int)) return 'O campo compressorid, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'name', String)) return 'O campo name, do tipo string, não está presente. Por favor, inclua-o na sua requisição.';
    return null;
  }
}
