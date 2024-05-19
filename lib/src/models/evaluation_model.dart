import 'dart:convert';
import 'package:backend/src/models/compressor_model.dart';
import 'package:backend/src/models/evaluation_coalescent_model.dart';
import 'package:backend/src/models/evaluation_photo_model.dart';
import 'package:backend/src/models/evaluation_techinician_model.dart';
import 'package:backend/src/models/person_model.dart';
import 'package:backend/src/shared/extensions/duration_extension.dart';
import 'package:backend/src/shared/extensions/string_extension.dart';
import 'package:intl/intl.dart';

class EvaluationModel {
  final int id;
  final DateTime creation;
  final PersonModel customer;
  final CompressorModel compressor;
  final String responsible;
  final Duration startTime;
  final Duration endTime;
  final int horimeter;
  final int airFilter;
  final int oilFilter;
  final int separator;
  final int oilType;
  final int oil;
  final String technicalAdvice;
  final String signaturePath;
  final List<EvaluationTechnicianModel> technicians;
  final List<EvaluationCoalescentModel> coalescents;
  final List<EvaluationPhotoModel> photos;
  EvaluationModel({
    required this.id,
    required this.creation,
    required this.customer,
    required this.responsible,
    required this.compressor,
    required this.startTime,
    required this.endTime,
    required this.horimeter,
    required this.airFilter,
    required this.oilFilter,
    required this.separator,
    required this.oilType,
    required this.oil,
    required this.technicalAdvice,
    required this.signaturePath,
    required this.technicians,
    required this.coalescents,
    required this.photos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'creation': DateFormat('yyyy-MM-dd').format(creation),
      'customer': customer.toMap(),
      'compressor': compressor.toMap(),
      'responsible': responsible,
      'starttime': startTime.formatedString(),
      'endtime': endTime.formatedString(),
      'horimeter': horimeter,
      'airfilter': airFilter,
      'oilfilter': oilFilter,
      'separator': separator,
      'oiltype': oilType,
      'oil': oil,
      'technicaladvice': technicalAdvice,
      'signaturepath': signaturePath,
      'technicians': technicians.map((x) => x.toMap()).toList(),
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
      'photos': photos.map((x) => x.toMap()).toList(),
    };
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: (map['id'] ?? 0) as int,
      creation: DateTime.parse(map['creation']),
      customer: PersonModel.fromMap(map['customer'] as Map<String, dynamic>),
      compressor: CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>),
      responsible: map['responsible'] as String,
      startTime: map['starttime'].toString().toDuration(),
      endTime: map['endtime'].toString().toDuration(),
      horimeter: (map['horimeter'] ?? 0) as int,
      airFilter: (map['airfilter'] ?? 0) as int,
      oilFilter: (map['oilfilter'] ?? 0) as int,
      separator: (map['separator'] ?? 0) as int,
      oilType: (map['oiltype'] ?? 0) as int,
      oil: (map['oil'] ?? 0) as int,
      technicalAdvice: (map['technicaladvice'] ?? '') as String,
      signaturePath: (map['signaturepath'] ?? '') as String,
      technicians: (map['technicians'] as List<dynamic>).map((technicianMap) {
        return EvaluationTechnicianModel.fromMap(technicianMap);
      }).toList(),
      coalescents: (map['coalescents'] as List<dynamic>).map((coalescentMap) {
        return EvaluationCoalescentModel.fromMap(coalescentMap);
      }).toList(),
      photos: (map['photos'] as List<dynamic>).map((photoMap) {
        return EvaluationPhotoModel.fromMap(photoMap);
      }).toList(),
    );
  }

  factory EvaluationModel.fromJsonAndObjects(
    Map<String, dynamic> map,
    PersonModel customer,
    CompressorModel compressor,
    List<EvaluationTechnicianModel> technicians,
    List<EvaluationCoalescentModel> coalescents,
    List<EvaluationPhotoModel> photos,
  ) {
    return EvaluationModel(
      id: (map['id'] ?? 0) as int,
      creation: (map['creation']),
      customer: customer,
      compressor: compressor,
      responsible: map['responsible'] as String,
      startTime: map['starttime'] as Duration,
      endTime: map['endtime'] as Duration,
      horimeter: (map['horimeter'] ?? 0) as int,
      airFilter: (map['airfilter'] ?? 0) as int,
      oilFilter: (map['oilfilter'] ?? 0) as int,
      separator: (map['separator'] ?? 0) as int,
      oilType: (map['oiltype'] ?? 0) as int,
      oil: (map['oil'] ?? 0) as int,
      technicalAdvice: map['technicaladvice'].toString(),
      signaturePath: map['signaturepath'].toString(),
      technicians: technicians,
      coalescents: coalescents,
      photos: photos,
    );
  }

  factory EvaluationModel.fromRequest(
    Map<String, dynamic> map,
    PersonModel customer,
    CompressorModel compressor,
  ) {
    return EvaluationModel(
      id: (map['id'] ?? 0) as int,
      creation: DateTime.now(),
      customer: customer,
      compressor: compressor,
      responsible: map['responsible'] as String,
      startTime: map['starttime'].toString().toDuration(),
      endTime: map['endtime'].toString().toDuration(),
      horimeter: (map['horimeter'] ?? 0) as int,
      airFilter: (map['airfilter'] ?? 0) as int,
      oilFilter: (map['oilfilter'] ?? 0) as int,
      separator: (map['separator'] ?? 0) as int,
      oilType: (map['oiltype'] ?? 0) as int,
      oil: (map['oil'] ?? 0) as int,
      technicalAdvice: map['technicaladvice'].toString(),
      signaturePath: map['signaturepath'].toString(),
      technicians: (map['technicians'] as List<dynamic>).map((technicianMap) {
        return EvaluationTechnicianModel.fromMap(technicianMap);
      }).toList(),
      coalescents: (map['coalescents'] as List<dynamic>).map((coalescentMap) {
        return EvaluationCoalescentModel.fromRequest(coalescentMap);
      }).toList(),
      photos: (map['photos'] as List<dynamic>).map((photoMap) {
        return EvaluationPhotoModel.fromMap(photoMap);
      }).toList(),
    );
  }
  String toJson() => json.encode(toMap());

  factory EvaluationModel.fromJson(String source) => EvaluationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  EvaluationModel copyWith({
    int? id,
    DateTime? creation,
    PersonModel? customer,
    CompressorModel? compressor,
    String? responsible,
    Duration? startTime,
    Duration? endTime,
    int? horimeter,
    int? airFilter,
    int? oilFilter,
    int? separator,
    int? oilType,
    int? oil,
    String? technicalAdvice,
    String? signaturePath,
    List<EvaluationTechnicianModel>? technicians,
    List<EvaluationCoalescentModel>? coalescents,
    List<EvaluationPhotoModel>? photos,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      creation: creation ?? this.creation,
      customer: customer ?? this.customer,
      compressor: compressor ?? this.compressor,
      responsible: responsible ?? this.responsible,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      horimeter: horimeter ?? this.horimeter,
      airFilter: airFilter ?? this.airFilter,
      oilFilter: oilFilter ?? this.oilFilter,
      separator: separator ?? this.separator,
      oilType: oilType ?? this.oilType,
      oil: oil ?? this.oil,
      technicalAdvice: technicalAdvice ?? this.technicalAdvice,
      signaturePath: signaturePath ?? this.signaturePath,
      technicians: technicians ?? this.technicians,
      coalescents: coalescents ?? this.coalescents,
      photos: photos ?? this.photos,
    );
  }

  @override
  String toString() {
    return 'EvaluationModel(id: $id, creation: ${DateFormat('yyyy-MM-dd').format(creation)} customer: ${customer.name}, compressor: ${compressor.name}, responsible: $responsible, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oilType: $oilType, oil: $oil, technicalAdvice: $technicalAdvice)';
  }
}
