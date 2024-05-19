import 'dart:math';

class RandomName {
  RandomName._();

  static String _generate({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static String photoName(String personDocument) {
    var documentNumber = personDocument.replaceAll('.', '').replaceAll('/', '').replaceAll('-', '');
    var randomName = _generate();
    var name = 'photos/$documentNumber/$randomName.jpg';
    return name;
  }

  static String signatureName(String personDocument) {
    var documentNumber = personDocument.replaceAll('.', '').replaceAll('/', '').replaceAll('-', '');
    var randomName = _generate();
    var name = 'signature/$documentNumber/$randomName.png';
    return name;
  }
}
