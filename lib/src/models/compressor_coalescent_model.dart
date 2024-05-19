import 'dart:convert';

class CompressorCoalescentModel {
  final int id;
  final int compressorId;
  final String name;
  CompressorCoalescentModel({required this.id, required this.compressorId, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'compressorid': compressorId,
      'name': name,
    };
  }

  factory CompressorCoalescentModel.fromMap(Map<String, dynamic> map) {
    return CompressorCoalescentModel(
      id: (map['id'] ?? 0) as int,
      compressorId: (map['compressorid'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompressorCoalescentModel.fromJson(String source) => CompressorCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoalescentModel(id: $id, compressorId: $compressorId, name: $name)';
  }
}
