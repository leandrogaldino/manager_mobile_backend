import 'dart:convert';

class PersonModel {
  final int id;
  final String document;
  final String name;
  final bool isTechnician;
  final bool isCustomer;
  PersonModel({
    required this.id,
    required this.document,
    required this.name,
    required this.isTechnician,
    required this.isCustomer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'document': document,
      'name': name,
      'istechnician': isTechnician,
      'iscustomer': isCustomer,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: (map['id'] ?? 0) as int,
      document: (map['document'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      isTechnician: map['istechnician'] == 0 ? false : true,
      isCustomer: map['iscustomer'] == 0 ? false : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) => PersonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonModel(id: $id, document: $document, name: $name, isTechnician: $isTechnician, isCustomer: $isCustomer)';
  }
}
