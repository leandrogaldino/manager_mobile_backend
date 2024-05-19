class DatabaseResult {
  final int affectedRows;
  final int? lastInsertedRowId;
  final List<Map<String, dynamic>>? dataSet;

  DatabaseResult({required this.affectedRows, this.lastInsertedRowId, this.dataSet});
}
