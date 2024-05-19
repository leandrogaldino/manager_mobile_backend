import 'dart:convert';

class EvaluationTechnicianModel {
  final int id;
  final int personid;

  EvaluationTechnicianModel({required this.id, required this.personid});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'personid': personid,
    };
  }

  factory EvaluationTechnicianModel.fromMap(Map<String, dynamic> map) {
    return EvaluationTechnicianModel(
      id: (map['id'] ?? 0) as int,
      personid: (map['personid'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationTechnicianModel.fromJson(String source) => EvaluationTechnicianModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationTechnicianModel(id: $id, personid: $personid)';

  EvaluationTechnicianModel copyWith({
    int? id,
    int? personid,
  }) {
    return EvaluationTechnicianModel(
      id: id ?? this.id,
      personid: personid ?? this.personid,
    );
  }
}
