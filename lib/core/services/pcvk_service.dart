import 'dart:convert';
import 'dart:io' show File;

import 'package:http/http.dart' as http;
import 'package:jawara/core/models/PCVK/batch_predict_response.dart';
import 'package:jawara/core/models/PCVK/health_response.dart';
import 'package:jawara/core/models/PCVK/models_response.dart';
import 'package:jawara/core/models/PCVK/predict_response.dart';

class PcvkService {
  final String _apiUrl =
      'https://pcvk-containerapp.lemonisland-43c085da.southeastasia.azurecontainerapps.io/api/';
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

  Future<PredictModelResponse> predict(
    File picture, {
    bool useSegmentation = true,
    String segMethod = 'u2netp',
    String modelType = 'mlpv2_auto-clahe',
    bool applyBrightnessContrast = true,
  }) async {
    final uri = _buildEndpoint('predict').replace(
      queryParameters: {
        'use_segmentation': useSegmentation.toString(),
        'seg_method': segMethod,
        'model_type': modelType,
        'apply_brightness_contrast': applyBrightnessContrast.toString(),
      },
    );
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        picture.path,
        contentType: http.MediaType('image', ''),
      ),
    );
    final response = await _client.send(request);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(await response.stream.bytesToString());
      return PredictModelResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to predict - ${response.statusCode}');
    }
  }

  Future<BatchPredictionResponse> batchPredict(
    List<File> pictures, {
    bool useSegmentation = true,
    String segMethod = 'u2netp',
    String modelType = 'mlpv2_auto-clahe',
    bool applyBrightnessContrast = true,
  }) async {
    final uri = _buildEndpoint('batch-predict').replace(
      queryParameters: {
        'use_segmentation': useSegmentation.toString(),
        'seg_method': segMethod,
        'model_type': modelType,
        'apply_brightness_contrast': applyBrightnessContrast.toString(),
      },
    );
    final request = http.MultipartRequest('POST', uri);
    for (var picture in pictures) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          picture.path,
          contentType: http.MediaType('image', ''),
        ),
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
