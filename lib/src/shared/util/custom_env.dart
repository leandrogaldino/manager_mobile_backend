import 'dart:io';
import '../extensions/string_extension.dart';

class CustomEnv {
  static Map<String, String> _map = {};
  static String _file = '.env';

  CustomEnv._();

  factory CustomEnv.fromFile(String file) {
    _file = file;
    return CustomEnv._();
  }

  static Future<T> get<T>({required String key}) async {
    if (_map.isEmpty) await _load();
    return _map[key]!.toType(T);
  }

  static Future<void> _load() async {
    List<String> rows = (await _readFile()).split('\n');
    _map = {for (var row in rows) row.split('=')[0].trim(): row.split('=')[1].trim()};
  }

  static Future<String> _readFile() async {
    return await File(_file).readAsString();
  }
}
