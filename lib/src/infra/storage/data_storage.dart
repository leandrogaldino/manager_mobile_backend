import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:backend/src/infra/storage/transfer_info.dart';
import 'package:backend/src/shared/util/custom_env.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class DataStorage {
  final _progressStreamController = StreamController<TransferInfo>.broadcast();
  Stream<TransferInfo> get progressStream => _progressStreamController.stream;
  Future<Bucket> _getbucket(AutoRefreshingAuthClient client) async {
    final storage = Storage(client, await CustomEnv.get<String>(key: 'gcp_project_name'));
    final bucketName = await CustomEnv.get<String>(key: 'gcp_bucket_name');
    final bucket = storage.bucket(bucketName);
    return bucket;
  }

  Future<AutoRefreshingAuthClient> _getClient() async {
    String credentialPath = 'storage-credentials.json';
    String json = await File(credentialPath).readAsString();
    return await auth.clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(json),
      [
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/devstorage.read_write',
      ],
    );
  }

  Future<Uint8List> downloadFile(String url) async {
    final client = await _getClient();
    final bucket = await _getbucket(client);
    var filename = url.split('/').last;
    final totalBytes = await bucket.info(filename).then((info) => info.length);
    var bytesDownloaded = 0;
    final result = <int>[];
    await for (var data in bucket.read(filename)) {
      bytesDownloaded += data.length;
      result.addAll(data);
      var progress = (bytesDownloaded / totalBytes * 100).toStringAsFixed(2);
      _progressStreamController.add(TransferInfo(double.parse(progress)));
    }
    client.close();
    return Uint8List.fromList(result);
  }

  Future<void> deleteFile(String filename) async {
    final client = await _getClient();
    final bucket = await _getbucket(client);
    await bucket.delete(filename);
  }

  Future<String> uploadFile(Uint8List fileBytes, String destination) async {
    final client = await _getClient();
    final bucket = await _getbucket(client);
    final totalBytes = fileBytes.length;
    var bytesUploaded = 0;
    const chunkSize = 1024;

    Stream<List<int>> streamWithProgress(Uint8List fileBytes) async* {
      for (var i = 0; i < totalBytes; i += chunkSize) {
        var chunkEnd = i + chunkSize;
        if (chunkEnd > totalBytes) {
          chunkEnd = totalBytes;
        }
        var chunk = fileBytes.sublist(i, chunkEnd);
        yield chunk;
        bytesUploaded += chunk.length;
        var progress = (bytesUploaded / totalBytes * 100).toStringAsFixed(2);
        _progressStreamController.add(TransferInfo(double.parse(progress)));
      }
    }

    final sink = bucket.write(
      destination,
      length: totalBytes,
    );
    await sink.addStream(streamWithProgress(fileBytes));
    await sink.close();
    client.close();

    return destination;
  }
}
