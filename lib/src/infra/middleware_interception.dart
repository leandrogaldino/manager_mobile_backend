import 'package:shelf/shelf.dart';

class MiddlewareInterception {
  Middleware get contentTypeJson {
    return createMiddleware(responseHandler: (Response res) {
      return res.change(
        headers: {'content-type': "application/json; charset=utf-8"},
      );
    });
  }
}
