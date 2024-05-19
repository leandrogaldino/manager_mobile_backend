class PersonSQL {
  PersonSQL._();
  static String get insert => '''
    INSERT INTO `person` (
      `id`,
      `document`,
      `name`,
      `istechnician`,
      `iscustomer`
    ) VALUES (
      ?,
      ?,
      ?,
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `person` SET
      `document` = ?,
      `name` = ?,
      `istechnician` = ?,
      `iscustomer` = ?
     WHERE `id` = ?
    ''';
  static String get getAll => '''
    SELECT
      `id`,
      `document`,
      `name`,
      `istechnician`,
      `iscustomer`
    FROM `person`
    ''';

  static String get getById => '$getAll WHERE `id` = ?';

  static String get delete => 'DELETE FROM `person` WHERE `id` = ?';

  static String get getIdByCode => 'SELECT `id` FROM `person` WHERE `accesscode` = ?';
}
