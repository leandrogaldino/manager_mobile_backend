import 'dart:convert';
import 'package:backend/src/apis/api.dart';
import 'package:backend/src/models/compressor_model.dart';
import 'package:backend/src/models/evaluation_model.dart';
import 'package:backend/src/models/person_model.dart';
import 'package:backend/src/services/compressor_service.dart';
import 'package:backend/src/services/evaluation_service.dart';
import 'package:backend/src/services/person_service.dart';
import 'package:backend/src/shared/util/messages.dart';
import 'package:backend/src/shared/exceptions/validation_exception.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class EvaluationApi extends Api {
  final EvaluationService _evaluationService;
  final PersonService _personService;
  final CompressorService _compressorService;

  EvaluationApi(
    this._evaluationService,
    this._personService,
    this._compressorService,
  );

  ///Retorna o handler responsável pelas rotas da API do compressor.
  @override
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false}) {
    Router router = Router();

    /// Salva ou atualiza uma avaliação.
    router.post('/evaluation', (Request req) async {
      try {
        String body = await req.readAsString();
        String? invalidBodyMessage = validateRequestBody(body);
        bool toInsert = isNew(body);
        if (invalidBodyMessage != null) return Response.badRequest(body: invalidBodyMessage);
        Map<String, dynamic> bodyMap = jsonDecode(body);
        PersonModel? customer = await _personService.getById(bodyMap['customerid']);
        CompressorModel? compressor = await _compressorService.getById(bodyMap['compressorid']);
        EvaluationModel evaluation = EvaluationModel.fromRequest(bodyMap, customer!, compressor!);
        int evaluationId = await _evaluationService.save(evaluation).then((value) => value.id);
        return Response.ok(toInsert ? '${Messages.saveSuccess}  Id: $evaluationId.' : Messages.updateSuccess);
      } on ValidationException catch (e) {
        return Response.badRequest(body: e.message);
      } catch (e) {
        return Response.internalServerError(body: '${Messages.saveError} [$e]');
      }
    });

    /// Busca todas asavaliações entre duas datas.
    router.get('/evaluations', (Request req) async {
      String? start = req.url.queryParameters['startdate'];
      String? end = req.url.queryParameters['enddate'];
      try {
        if (start == null) return Response.badRequest(body: Messages.missingStartDate);
        if (end == null) return Response.badRequest(body: Messages.missingEndDate);
        var startDate = DateTime.tryParse(start);
        var endDate = DateTime.tryParse(end);
        if (startDate == null || endDate == null) return Response.badRequest(body: Messages.badDate);
        List<EvaluationModel> listModel = await _evaluationService.getByDate(startDate, endDate);
        List<Map> listMap = listModel.map((e) => e.toMap()).toList();
        return Response.ok(jsonEncode(listMap));
      } catch (e) {
        return Response.internalServerError(body: '${Messages.fetchError} [$e]');
      }
    });

    ///Busca uma avaliação pelo seu id.
    router.get('/evaluation', (Request req) async {
      String? id = req.url.queryParameters['id'];
      try {
        if (id == null) return Response.badRequest(body: Messages.missingId);
        var model = await _evaluationService.getById(int.parse(id));
        if (model != null) {
          return Response.ok(jsonEncode(model.toMap()));
        } else {
          return Response.notFound(Messages.recordNotFound);
        }
      } catch (e) {
        return Response.internalServerError(body: '${Messages.fetchError} [$e]');
      }
    });

    ///Deleta uma avaliação pelo seu id.
    router.delete('/evaluation', (Request req) async {
      String? id = req.url.queryParameters['id'];
      try {
        if (id == null) return Response.badRequest(body: Messages.missingId);
        var result = await _evaluationService.delete(int.parse(id));
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
    if (!containsField(body, 'id', int)) return 'O campo id, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição. caso esteja salvando um novo registro o valor é 0.';
    if (!containsField(body, 'customerid', int)) return 'O campo customerid, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'compressorid', int)) return 'O campo compressorid, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'responsible', String)) return 'O campo responsible, do tipo string, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'horimeter', int)) return 'O campo horimeter, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'airfilter', int)) return 'O campo airfilter, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'oilfilter', int)) return 'O campo oilfilter, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'separator', int)) return 'O campo separator, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'oiltype', int)) return 'O campo oiltype, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'oil', int)) return 'O campo oil, do tipo inteiro, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'technicaladvice', String)) return 'O campo technicaladvice, do tipo string, não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'technicians', List)) return 'O campo coalescents, do tipo lista, não está presente. Por favor, inclua-o na sua requisição.';
    if (!collectionContainsField(body, 'technicians', 'id', int)) return 'O campo id, do tipo inteiro, de um ou mais técnicos não está presente. Por favor, inclua-o na sua requisição. caso esteja salvando um novo registro o valor é 0.';
    if (!collectionContainsField(body, 'technicians', 'personid', int)) return 'O campo personid, do tipo inteiro, de um ou mais técnicos não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'coalescents', List)) return 'O campo coalescents, do tipo lista, não está presente. Por favor, inclua-o na sua requisição.';
    if (!collectionContainsField(body, 'coalescents', 'id', int)) return 'O campo id, do tipo inteiro, de um ou mais coalescentes não está presente. Por favor, inclua-o na sua requisição. caso esteja salvando um novo registro o valor é 0.';
    if (!collectionContainsField(body, 'coalescents', 'compressorcoalescentid', int)) return 'O campo compressorcoalescentid, do tipo inteiro, de um ou mais coalescentes não está presente. Por favor, inclua-o na sua requisição.';
    if (!collectionContainsField(body, 'coalescents', 'nextchange', String)) return 'O campo nextchange, do tipo string, de um ou mais coalescentes não está presente. Por favor, inclua-o na sua requisição.';
    if (!containsField(body, 'photos', List)) return 'O campo photos, do tipo lista, não está presente. Por favor, inclua-o na sua requisição.';
    if (!collectionContainsField(body, 'photos', 'id', int)) return 'O campo id, do tipo inteiro, de uma ou mais fotos não está presente. Por favor, inclua-o na sua requisição. caso esteja salvando um novo registro o valor é 0.';
    if (!collectionContainsField(body, 'photos', 'photopath', String)) return 'O campo photopath, do tipo string, de uma ou mais fotos não está presente. Por favor, inclua-o na sua requisição.';
    return null;
  }
}
