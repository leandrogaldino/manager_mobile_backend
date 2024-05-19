import 'dart:io';
import 'dart:typed_data';
import 'package:backend/src/shared/util/random_name.dart';
import 'package:intl/intl.dart';
import 'package:backend/src/dao/compressor_dao.dart';
import 'package:backend/src/dao/dao.dart';
import 'package:backend/src/dao/dao_get_by_date.dart';
import 'package:backend/src/dao/person_dao.dart';
import 'package:backend/src/infra/database/mysql/mysql.dart';
import 'package:backend/src/infra/database/sql/evaluation_colescent_sql.dart';
import 'package:backend/src/infra/database/sql/evaluation_photo_sql.dart';
import 'package:backend/src/infra/database/sql/evaluation_sql.dart';
import 'package:backend/src/infra/database/sql/evaluation_technician_sql.dart';
import 'package:backend/src/infra/storage/data_storage.dart';
import 'package:backend/src/models/evaluation_coalescent_model.dart';
import 'package:backend/src/models/evaluation_model.dart';
import 'package:backend/src/models/evaluation_photo_model.dart';
import 'package:backend/src/models/evaluation_techinician_model.dart';

class EvaluationDAO implements DAO<EvaluationModel>, GetByDateDAO<EvaluationModel> {
  final MySql _db;
  final PersonDAO _personDAO;
  final CompressorDAO _compressorDAO;
  final DataStorage _dataStorage;
  EvaluationDAO(
    this._db,
    this._personDAO,
    this._compressorDAO,
    this._dataStorage,
  );
  @override
  Future<EvaluationModel> create(EvaluationModel value) async {
    List<String> uploadedFiles = [];
    String path;
    Uint8List fileBytes;
    String fileUrl;

    try {
      path = RandomName.signatureName(value.customer.document);
      fileBytes = await File(value.signaturePath).readAsBytes();
      fileUrl = await _dataStorage.uploadFile(fileBytes, path);
      uploadedFiles.add(fileUrl);
      value = value.copyWith(signaturePath: fileUrl);
      await _db.startTransaction();
      var evaluationId = await _db.execute(
        EvaluationSQL.insert,
        values: [
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          value.customer.id,
          value.compressor.id,
          value.responsible,
          value.startTime.toString(),
          value.endTime.toString(),
          value.horimeter,
          value.airFilter,
          value.oilFilter,
          value.separator,
          value.oilType,
          value.oil,
          value.technicalAdvice,
          value.signaturePath,
        ],
      ).then((value) => value.lastInsertedRowId);
      value = value.copyWith(id: evaluationId);
      for (var technician in value.technicians) {
        var technicianId = await _db.execute(
          EvaluationTechnicianSQL.insert,
          values: [
            value.id,
            technician.personid,
          ],
        ).then((value) => value.lastInsertedRowId);
        technician = technician.copyWith(id: technicianId);
      }

      for (var coalescent in value.coalescents) {
        var coalescentId = await _db.execute(
          EvaluationCoalescentSQL.insert,
          values: [
            value.id,
            coalescent.compressorCoalescentId,
            DateFormat('yyyy-MM-dd').format(coalescent.nextChange),
          ],
        ).then((value) => value.lastInsertedRowId);
        coalescent = coalescent.copyWith(id: coalescentId);
      }

      for (var photo in value.photos) {
        path = RandomName.photoName(value.customer.document);
        fileBytes = await File(photo.photoPath).readAsBytes();
        fileUrl = await _dataStorage.uploadFile(fileBytes, path);
        uploadedFiles.add(fileUrl);
        var photoId = await _db.execute(
          EvaluationPhotoSQL.insert,
          values: [
            value.id,
            fileUrl,
          ],
        ).then((value) => value.lastInsertedRowId);
        photo = photo.copyWith(id: photoId, photoPath: fileUrl);
      }

      _db.commitTransaction();
      return value;
    } catch (e) {
      _db.rollbackTransaction();
      for (var file in uploadedFiles) {
        await _dataStorage.deleteFile(file);
      }
      rethrow;
    }
  }

  Future<void> _updateTechnicians(EvaluationModel evaluation) async {
    var dbTechniciansMap = await _db.execute(EvaluationTechnicianSQL.getByEvaluationId, values: [evaluation.id]).then((value) => value.dataSet);
    dbTechniciansMap ??= [];
    var dbTechniciansModel = dbTechniciansMap.map((e) => EvaluationTechnicianModel.fromMap(e)).toList();
    List<EvaluationTechnicianModel> techniciansToSave = evaluation.technicians.where((technician) => !dbTechniciansModel.any((dbTechnician) => dbTechnician.id == technician.id)).toList();
    List<EvaluationTechnicianModel> techniciansToDelete = dbTechniciansModel.where((dbTechnician) => !evaluation.technicians.any((technician) => technician.id == dbTechnician.id)).toList();
    List<EvaluationTechnicianModel> techniciansToUpdate = evaluation.technicians.where((technician) => dbTechniciansModel.any((dbTechnician) => dbTechnician.id == technician.id)).toList();

    for (var technician in techniciansToSave) {
      var technicianId = await _db.execute(
        EvaluationTechnicianSQL.insert,
        values: [
          evaluation.id,
          technician.personid,
        ],
      ).then((value) => value.lastInsertedRowId);
      technician = technician.copyWith(id: technicianId);
    }
    for (var technician in techniciansToDelete) {
      await _db.execute(
        EvaluationTechnicianSQL.delete,
        values: [technician.id],
      );
    }
    for (var technician in techniciansToUpdate) {
      await _db.execute(
        EvaluationTechnicianSQL.update,
        values: [
          evaluation.id,
          technician.personid,
          technician.id,
        ],
      );
    }
  }

  Future<void> _updateCoalescents(EvaluationModel evaluation) async {
    var dbCoalescentsMap = await _db.execute(EvaluationCoalescentSQL.getByEvaluationId, values: [evaluation.id]).then((value) => value.dataSet);
    dbCoalescentsMap ??= [];
    var dbCoalescentsModel = dbCoalescentsMap.map((e) => EvaluationCoalescentModel.fromMap(e)).toList();
    List<EvaluationCoalescentModel> coalescentsToSave = evaluation.coalescents.where((coalescent) => !dbCoalescentsModel.any((dbCoalescent) => dbCoalescent.id == coalescent.id)).toList();
    List<EvaluationCoalescentModel> coalescentsToDelete = dbCoalescentsModel.where((dbCoalescent) => !evaluation.coalescents.any((coalescent) => coalescent.id == dbCoalescent.id)).toList();
    List<EvaluationCoalescentModel> coalescentsToUpdate = evaluation.coalescents.where((coalescent) => dbCoalescentsModel.any((dbCoalescent) => dbCoalescent.id == coalescent.id)).toList();
    for (var coalescent in coalescentsToSave) {
      var coalescentId = await _db.execute(
        EvaluationCoalescentSQL.insert,
        values: [
          evaluation.id,
          coalescent.compressorCoalescentId,
          DateFormat('yyyy-MM-dd').format(coalescent.nextChange),
        ],
      ).then((value) => value.lastInsertedRowId);
      coalescent = coalescent.copyWith(id: coalescentId);
    }
    for (var coalescent in coalescentsToDelete) {
      await _db.execute(
        EvaluationCoalescentSQL.delete,
        values: [coalescent.id],
      );
    }
    for (var coalescent in coalescentsToUpdate) {
      await _db.execute(
        EvaluationCoalescentSQL.update,
        values: [
          evaluation.id,
          coalescent.compressorCoalescentId,
          DateFormat('yyyy-MM-dd').format(coalescent.nextChange),
          coalescent.id,
        ],
      );
    }
  }

  Future<void> _updatePhotos(EvaluationModel evaluation) async {
    List<String> uploadedFiles = [];
    String path;
    Uint8List fileBytes;
    String fileUrl;

    var dbPhotosMap = await _db.execute(EvaluationPhotoSQL.getByEvaluationId, values: [evaluation.id]).then((value) => value.dataSet);
    dbPhotosMap ??= [];
    var dbPhotosModel = dbPhotosMap.map((e) => EvaluationPhotoModel.fromMap(e)).toList();
    List<EvaluationPhotoModel> photosToSave = evaluation.photos.where((photo) => !dbPhotosModel.any((dbPhoto) => dbPhoto.id == photo.id)).toList();
    List<EvaluationPhotoModel> photosToDelete = dbPhotosModel.where((dbPhoto) => !evaluation.photos.any((photo) => photo.id == dbPhoto.id)).toList();

    for (var photo in photosToSave) {
      path = RandomName.photoName(evaluation.customer.document);
      fileBytes = await File(photo.photoPath).readAsBytes();
      fileUrl = await _dataStorage.uploadFile(fileBytes, path);
      uploadedFiles.add(fileUrl);

      var photoId = await _db.execute(
        EvaluationPhotoSQL.insert,
        values: [
          evaluation.id,
          fileUrl,
        ],
      ).then((value) => value.lastInsertedRowId);
      photo = photo.copyWith(
        id: photoId,
        photoPath: fileUrl,
      );
    }
    for (var photo in photosToDelete) {
      path = photo.photoPath;
      await _dataStorage.deleteFile(path);
      await _db.execute(
        EvaluationPhotoSQL.delete,
        values: [photo.id],
      );
    }
  }

  @override
  Future<EvaluationModel> update(EvaluationModel value) async {
    try {
      await _db.startTransaction();
      await _db.execute(EvaluationSQL.update, values: [
        value.customer.id,
        value.compressor.id,
        value.responsible,
        value.startTime.toString(),
        value.endTime.toString(),
        value.horimeter,
        value.airFilter,
        value.oilFilter,
        value.separator,
        value.oilType,
        value.oil,
        value.technicalAdvice,
        value.id,
      ]);
      await _updateTechnicians(value);
      await _updateCoalescents(value);
      await _updatePhotos(value);
      await _db.commitTransaction();
      return value;
    } catch (e) {
      await _db.rollbackTransaction();
      rethrow;
    }
  }

  @override
  Future<bool> delete(int id) async {
    var result = await _db.execute(EvaluationSQL.delete, values: [id]);
    if (result.affectedRows == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<EvaluationModel?> getById(int id) async {
    var evaluationListMap = await _db.execute(EvaluationSQL.getById, values: [id]).then((value) => value.dataSet);
    if (evaluationListMap != null && evaluationListMap.length == 1) {
      var customer = await _personDAO.getById(evaluationListMap.first['customerid']);
      var compressor = await _compressorDAO.getById(evaluationListMap.first['compressorid']);
      var techniciansMap = await _db.execute(EvaluationTechnicianSQL.getByEvaluationId, values: [evaluationListMap.first['id']]).then((value) => value.dataSet);
      var technicians = techniciansMap?.map((e) => EvaluationTechnicianModel.fromMap(e)).toList();
      var coalescentsMap = await _db.execute(EvaluationCoalescentSQL.getByEvaluationId, values: [evaluationListMap.first['id']]).then((value) => value.dataSet);
      var coalescents = coalescentsMap?.map((e) => EvaluationCoalescentModel.fromMap(e)).toList() ?? [];
      var photosMap = await _db.execute(EvaluationPhotoSQL.getByEvaluationId, values: [evaluationListMap.first['id']]).then((value) => value.dataSet);
      var photos = photosMap?.map((e) => EvaluationPhotoModel.fromMap(e)).toList() ?? [];
      return EvaluationModel.fromJsonAndObjects(evaluationListMap.first, customer!, compressor!, technicians!, coalescents, photos);
    }
    return null;
  }

  @override
  Future<List<EvaluationModel>> getByDate(DateTime start, DateTime end) async {
    var evaluationListMap = await _db.execute(EvaluationSQL.getByDate, values: [DateFormat('yyyy-MM-dd').format(start), DateFormat('yyyy-MM-dd').format(end)]).then((value) => value.dataSet);
    if (evaluationListMap != null && evaluationListMap.isNotEmpty) {
      List<EvaluationModel> evaluations = [];
      for (var evaluationMap in evaluationListMap) {
        var customer = await _personDAO.getById(evaluationMap['customerid']);
        var compressor = await _compressorDAO.getById(evaluationMap['compressorid']);
        var techniciansMap = await _db.execute(EvaluationTechnicianSQL.getByEvaluationId, values: [evaluationMap['id']]).then((value) => value.dataSet);
        var technicians = techniciansMap?.map((e) => EvaluationTechnicianModel.fromMap(e)).toList();
        var coalescentsMap = await _db.execute(EvaluationCoalescentSQL.getByEvaluationId, values: [evaluationMap['id']]).then((value) => value.dataSet);
        var coalescents = coalescentsMap?.map((e) => EvaluationCoalescentModel.fromMap(e)).toList() ?? [];
        var photosMap = await _db.execute(EvaluationPhotoSQL.getByEvaluationId, values: [evaluationMap['id']]).then((value) => value.dataSet);
        var photos = photosMap?.map((e) => EvaluationPhotoModel.fromMap(e)).toList() ?? [];
        var evaluation = EvaluationModel.fromJsonAndObjects(evaluationMap, customer!, compressor!, technicians!, coalescents, photos);
        evaluations.add(evaluation);
      }
      return evaluations;
    }
    return [];
  }
}
