class CompressorCoalescentSQL {
  CompressorCoalescentSQL._();
  static String get insert => '''
    INSERT INTO `compressorcoalescent` (
      `id`,
      `compressorid`,
      `name`
    ) VALUES (
      ?,
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `compressorcoalescent` SET
      `name` = ?
     WHERE `id` = ?
    ''';

  static String get getByCompressorId => '''
    SELECT
      `id`,
      `compressorid`,
      `name`
    FROM `compressorcoalescent`
    WHERE `compressorid` = ?
    ''';

  static String get delete => 'DELETE FROM `compressorcoalescent` WHERE `id` = ?';

  static String get getAll => '''
    SELECT
      `id`,
      `compressorid`,
      `name`
    FROM `compressorcoalescent`
    ''';

  static String get getById => '$getAll WHERE `id` = ?';
}
