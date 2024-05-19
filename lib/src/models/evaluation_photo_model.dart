import 'dart:convert';

class EvaluationPhotoModel {
  final int id;
  final String photoPath;

  EvaluationPhotoModel({
    required this.id,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'photopath': photoPath,
    };
  }

  factory EvaluationPhotoModel.fromMap(Map<String, dynamic> map) {
    return EvaluationPhotoModel(
      id: (map['id'] ?? 0) as int,
      photoPath: map['photopath'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationPhotoModel.fromJson(String source) => EvaluationPhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  EvaluationPhotoModel copyWith({
    int? id,
    String? photoPath,
  }) {
    return EvaluationPhotoModel(
      id: id ?? this.id,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  String toString() {
    return 'EvaluationPhotoModel(id: $id, photoPath: $photoPath)';
  }
}
