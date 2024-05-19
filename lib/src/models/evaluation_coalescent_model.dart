import 'dart:convert';

import 'package:intl/intl.dart';

class EvaluationCoalescentModel {
  final int id;
  final int compressorCoalescentId;
  final DateTime nextChange;

  EvaluationCoalescentModel({required this.id, required this.compressorCoalescentId, required this.nextChange});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'compressorcoalescentid': compressorCoalescentId,
      'nextchange': DateFormat('yyyy-MM-dd').format(nextChange),
    };
  }

  factory EvaluationCoalescentModel.fromMap(Map<String, dynamic> map) {
    return EvaluationCoalescentModel(
      id: (map['id'] ?? 0) as int,
      compressorCoalescentId: (map['compressorcoalescentid'] ?? 0) as int,
      nextChange: map['nextchange'],
    );
  }

  factory EvaluationCoalescentModel.fromRequest(Map<String, dynamic> map) {
    return EvaluationCoalescentModel(
      id: (map['id'] ?? 0) as int,
      compressorCoalescentId: (map['compressorcoalescentid'] ?? 0) as int,
      nextChange: DateTime.parse(map['nextchange']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationCoalescentModel.fromJson(String source) => EvaluationCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EvaluationCoalescentModel(id: $id, compressorCoalescentId: $compressorCoalescentId, nextChange: $nextChange)';
  }

  EvaluationCoalescentModel copyWith({
    int? id,
    int? compressorCoalescentId,
    DateTime? nextChange,
  }) {
    return EvaluationCoalescentModel(
      id: id ?? this.id,
      compressorCoalescentId: compressorCoalescentId ?? this.compressorCoalescentId,
      nextChange: nextChange ?? this.nextChange,
    );
  }
}
