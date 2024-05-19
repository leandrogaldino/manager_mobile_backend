// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:backend/src/apis/auth_api.dart';
import 'package:backend/src/apis/compressor_api.dart';
import 'package:backend/src/apis/compressor_coalescent_api.dart';
import 'package:backend/src/apis/evaluation_api.dart';
import 'package:backend/src/apis/person_api.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  final AuthApi _authApi;
  final PersonApi _personApi;
  final CompressorApi _compressorApi;
  final CompressorCoalescentApi _compressorCoalescentApi;
  final EvaluationApi _evaluationApi;
  AppRouter(
    this._authApi,
    this._personApi,
    this._compressorApi,
    this._compressorCoalescentApi,
    this._evaluationApi,
  );
  Router get routes {
    final router = Router();
    router.mount('/', _authApi.getHandler());
    router.mount('/', _personApi.getHandler(isSecurity: true));
    router.mount('/', _compressorApi.getHandler(isSecurity: true));
    router.mount('/', _compressorCoalescentApi.getHandler(isSecurity: true));
    router.mount('/', _evaluationApi.getHandler(isSecurity: true));
    return router;
  }
}
