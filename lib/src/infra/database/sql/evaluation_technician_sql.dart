class EvaluationTechnicianSQL {
  EvaluationTechnicianSQL._();
  static String get insert => '''
    INSERT INTO `evaluationtechnician` (
      `evaluationid`,
      `personid`
    ) VALUES (
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `evaluationtechnician` SET
      `evaluationid` = ?,
      `personid` = ?
    WHERE `id` = ?
    ''';

  static String get getById => '''
    SELECT
      `id`,
      `evaluationid`,
      `personid`
    FROM `evaluationtechnician`
    WHERE `id` = ?
    ''';

  static String get getByEvaluationId => '''
    SELECT
      `id`,
      `evaluationid`,
      `personid`
    FROM `evaluationtechnician`
    WHERE `evaluationid` = ?
    ''';

  static String get delete => 'DELETE FROM `evaluationtechnician` WHERE `id` = ?';
}
