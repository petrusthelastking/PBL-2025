import 'dart:convert';
import 'dart:io' show File;

import 'package:http/http.dart' as http;
import 'package:jawara/core/models/PCVK/batch_predict_response.dart';
import 'package:jawara/core/models/PCVK/health_response.dart';
import 'package:jawara/core/models/PCVK/models_response.dart';
import 'package:jawara/core/models/PCVK/predict_response.dart';

class PcvkService {
  final String _apiUrl =
      'https://pcvk-containerapp.lemonisland-43c085da.southeastasia.azurecontainerapps.io/';
  late final http.Client _client;

  PcvkService({http.Client? httpClient}) {
    _client = httpClient ?? http.Client();
  }

  Uri _buildEndpoint(String endpoint) => Uri.parse('$_apiUrl$endpoint');

  Future<HealthModelResponse> getHealth() async {
    final response = await _client.get(_buildEndpoint('health'));
    if (response.statusCode == 200) {
      return HealthModelResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch health - ${response.statusCode}');
    }
  }

  Future<List<String>> getClasses() async {
    final response = await _client.get(_buildEndpoint('classes'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body)['classes']);
    } else {
      throw Exception('Failed to fetch classes - ${response.statusCode}');
    }
  }

  Future<ModelsModelResponse> getModels() async {
    final response = await _client.get(_buildEndpoint('models'));
    if (response.statusCode == 200) {
      return ModelsModelResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch models - ${response.statusCode}');
    }
  }

  Future<PredictModelResponse> predict(File picture) async {
    final request = http.MultipartRequest('POST', _buildEndpoint('predict'));
    request.files.add(
      await http.MultipartFile.fromPath('picture', picture.path),
    );
    final response = await _client.send(request);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(await response.stream.bytesToString());
      return PredictModelResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to predict - ${response.statusCode}');
    }
  }

  Future<BatchPredictionResponse> batchPredict(List<File> pictures) async {
    final request = http.MultipartRequest(
      'POST',
      _buildEndpoint('batch-predict'),
    );
    for (var picture in pictures) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', picture.path),
      );
    }
    final response = await _client.send(request);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(await response.stream.bytesToString());
      return BatchPredictionResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to predict - ${response.statusCode}');
    }
  }
}
