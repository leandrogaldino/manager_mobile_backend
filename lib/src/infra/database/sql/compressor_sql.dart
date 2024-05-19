class CompressorSQL {
  CompressorSQL._();
  static String get insert => '''
    INSERT INTO `compressor` (
      `id`,
      `personid`,
      `name`
    ) VALUES (
      ?,
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `compressor` SET
      `name` = ?
     WHERE `id` = ?
    ''';
  static String get getAll => '''
    SELECT
      `id`,
      `personid`,
      `name`
    FROM `compressor`
    ''';

  static String get getById => '$getAll WHERE `id` = ?';

  static String get getByPersonId => '''
    $getAll
    WHERE `personid` = ?
    ''';

  static String get delete => 'DELETE FROM `compressor` WHERE `id` = ?';
}
