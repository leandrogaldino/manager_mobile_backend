class EvaluationCoalescentSQL {
  EvaluationCoalescentSQL._();
  static String get insert => '''
    INSERT INTO `evaluationcoalescent` (
      `evaluationid`,
      `compressorcoalescentid`,
      `nextchange`
    ) VALUES (
      ?,
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `evaluationcoalescent` SET
      `evaluationid` = ?,
      `compressorcoalescentid` = ?,
      `nextchange` = ?
    WHERE `id` = ?
    ''';

  static String get getById => '''
    SELECT
      `id`,
      `evaluationid`,
      `compressorcoalescentid`,
      `nextchange`
    FROM `evaluationcoalescent`
    WHERE `id` = ?
    ''';

  static String get getByEvaluationId => '''
    SELECT
      `id`,
      `evaluationid`,
      `compressorcoalescentid`,
      `nextchange`
    FROM `evaluationcoalescent`
    WHERE `evaluationid` = ?
    ''';

  static String get delete => 'DELETE FROM `evaluationcoalescent` WHERE `id` = ?';
}
