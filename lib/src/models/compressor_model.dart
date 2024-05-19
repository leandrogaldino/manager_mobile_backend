// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:backend/src/models/compressor_coalescent_model.dart';

class CompressorModel {
  final int id;
  final int personId;
  final String name;
  final List<CompressorCoalescentModel> coalescents;
  CompressorModel({
    required this.id,
    required this.personId,
    required this.name,
    required this.coalescents,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'personid': personId,
      'name': name,
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
    };
  }

  factory CompressorModel.create(Map<String, dynamic> map, List<CompressorCoalescentModel> coalescents) {
    return CompressorModel(
      id: (map['id'] ?? 0) as int,
      personId: (map['personid'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      coalescents: coalescents,
    );
  }

  factory CompressorModel.fromMap(Map<String, dynamic> map) {
    return CompressorModel(
        id: (map['id'] ?? 0) as int,
        personId: (map['personid'] ?? 0) as int,
        name: (map['name'] ?? '') as String,
        coalescents: (map['coalescents'] as List<dynamic>).map((coalescentMap) {
          return CompressorCoalescentModel.fromMap(coalescentMap);
        }).toList());
  }

  factory CompressorModel.fromJson(String source) => CompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CompressorModel(id: $id, personId: $personId, name: $name, coalescents: [${coalescents.map((e) => e.name).join(', ')}])';

  CompressorModel copyWith({
    int? id,
    int? personId,
    String? name,
    List<CompressorCoalescentModel>? coalescents,
  }) {
    return CompressorModel(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      name: name ?? this.name,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  String toJson() => json.encode(toMap());
}
