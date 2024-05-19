import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../infra/dependency_injector/dependency_injector.dart';
import '../infra/security/security_service.dart';

abstract class Api {
  Handler getHandler({List<Middleware>? middlewares, bool isSecurity = false});

  Handler createHandler({required Handler router, required List<Middleware>? middlewares, bool isSecurity = false}) {
    middlewares ??= [];
    if (isSecurity) {
      var securityService = DependencyInjector().get<SecurityService>();
      middlewares.addAll([securityService.authorization, securityService.verifyJwt]);
    }
    var pipe = Pipeline();
    for (var m in middlewares) {
      pipe = pipe.addMiddleware(m);
    }
    return pipe.addHandler(router);
  }

  bool isAJson(String body) {
    try {
      jsonDecode(body);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool containsField(String body, String field, Type type) {
    Map<String, dynamic> jsonMap = jsonDecode(body);
    if (jsonMap.containsKey(field) && jsonMap[field].runtimeType == type) {
      return true;
    } else {
      return false;
    }
  }

  bool collectionContainsField(String body, String collection, String field, Type type) {
    Map<String, dynamic> jsonMap = jsonDecode(body);
    List<dynamic> coalescentsList = jsonMap[collection];
    for (var item in coalescentsList) {
      if (item is Map<String, dynamic> && item.containsKey(field) && item[field].runtimeType == type) {
        return true;
      }
    }
    return false;
  }

  bool isNew(String body) {
    Map<String, dynamic> jsonMap = jsonDecode(body);
    if (jsonMap.containsKey('id') && jsonMap['id'].runtimeType == int) {
      if (jsonMap['id'] <= 0) return true;
    }
    return false;
  }
}
