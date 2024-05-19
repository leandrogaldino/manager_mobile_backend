class EvaluationSQL {
  EvaluationSQL._();

  static String get insert => '''
    INSERT INTO `evaluation` (
      `creation`,
      `customerid`,
      `compressorid`,
      `responsible`,
      `starttime`,
      `endtime`,
      `horimeter`,
      `airfilter`,
      `oilfilter`,
      `separator`,
      `oiltype`,
      `oil`,
      `technicaladvice`,
      `signaturepath`
    ) VALUES (
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?,
      ?
    )
    ''';

  static String get update => '''
    UPDATE `evaluation` SET
      `customerid` = ?,
      `compressorid` = ?,
      `responsible` = ?,
      `starttime` = ?,
      `endtime` = ?,
      `horimeter` = ?,
      `airfilter` = ?,
      `oilfilter` = ?,
      `separator` = ?,
      `oiltype` = ?,
      `oil` = ?,
      `technicaladvice` = ?
     WHERE `id` = ?
    ''';
  static String get getAll => '''
    SELECT
      `id`,
      `creation`,
      `customerid`,
      `compressorid`,
      `responsible`,
      `starttime`,
      `endtime`,
      `horimeter`,
      `airfilter`,
      `oilfilter`,
      `separator`,
      `oiltype`,
      `oil`,
      `technicaladvice`,
      `signaturepath`
    FROM `evaluation`
    ''';

  static String get getById => '$getAll WHERE `id` = ?';

  static String get getByDate => '''
    $getAll
    WHERE `creation` BETWEEN ? AND ?
    ''';

  static String get delete => 'DELETE FROM `evaluation` WHERE `id` = ?';
}
