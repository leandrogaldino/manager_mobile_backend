class EvaluationPhotoSQL {
  EvaluationPhotoSQL._();

  static String get insert => '''
    INSERT INTO `evaluationphoto` (
      `evaluationid`,
      `photopath`
    ) VALUES (
      ?,
      ?
    )
    ''';

  static String get getById => '''
    SELECT
      `id`,
      `evaluationid`,
      `photopath`
    FROM `evaluationphoto`
    WHERE `id` = ?
    ''';

  static String get getByEvaluationId => '''
    SELECT
      `id`,
      `evaluationid`,
      `photopath`
    FROM `evaluationphoto`
    WHERE `evaluationid` = ?
    ''';

  static String get delete => 'DELETE FROM `evaluationphoto` WHERE `id` = ?';
}
