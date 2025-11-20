// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jawara/core/models/PCVK/batch_predict_response.dart';
import 'package:jawara/core/models/PCVK/health_response.dart';
import 'package:jawara/core/models/PCVK/models_response.dart';
import 'package:jawara/core/models/PCVK/predict_response.dart';
import 'package:jawara/core/services/pcvk_service.dart';

void main() {
  group('PcvkService - API Tests', () {
    late PcvkService pcvkService;

    setUp(() {
      pcvkService = PcvkService();
    });

    group('getHealth', () {
      test('returns HealthModelResponse on successful response', () async {
        // Act
        final result = await pcvkService.getHealth();

        // Assert
        expect(result, isA<HealthModelResponse>());
        expect(result.status, isNotEmpty);
        expect(result.device, isNotEmpty);
        expect(result.numClasses, greaterThan(0));
        expect(result.classNames, isNotEmpty);
        expect(result.availableModels, isNotEmpty);
      });
    });

    group('getClasses', () {
      test('returns list of classes on successful response', () async {
        // Act
        final result = await pcvkService.getClasses();

        // Assert
        expect(result, isA<List<String>>());
        expect(result, isNotEmpty);
        expect(result.length, greaterThan(0));
      });
    });

    group('getModels', () {
      test('returns ModelsModelResponse on successful response', () async {
        // Act
        final result = await pcvkService.getModels();

        // Assert
        expect(result, isA<ModelsModelResponse>());
        expect(result.totalModels, greaterThan(0));
        expect(result.availableModels, isNotEmpty);
        expect(result.models, isNotEmpty);
      });
    });

    group('predict', () {
      test('returns PredictModelResponse on successful prediction', () async {
        final testImagePath = 'test/fixtures/test_images/1.jpg';
        final testFile = File(testImagePath);

        if (!await testFile.exists()) {
          print('Skipping predict test - no test image at: $testImagePath');
          print('Please provide a test image to run this test');
          return;
        }

        // Act
        final result = await pcvkService.predict(testFile);

        // Assert
        expect(result, isA<PredictModelResponse>());
        expect(result.fileName, isNotEmpty);
        expect(result.predictedClass, isNotEmpty);
        expect(result.confidence, greaterThan(0));
        expect(result.confidence, lessThanOrEqualTo(1));
        expect(result.allConfidences, isNotEmpty);
        expect(result.device, isNotEmpty);
        expect(result.modelType, isNotEmpty);
      }, skip: false);
    });

    group('batchPredict', () {
      test(
        'returns BatchPredictionResponse on successful batch prediction',
        () async {
          final testImagePaths = [
            'test/fixtures/test_images/1.jpg',
            'test/fixtures/test_images/2.jpeg',
          ];

          final testFiles = testImagePaths.map((path) => File(path)).toList();

          // Check if test files exist
          final allExist = await Future.wait(
            testFiles.map((f) => f.exists()),
          ).then((results) => results.every((exists) => exists));

          if (!allExist) {
            print('Skipping batch predict test - test images not found');
            print('Expected images at: $testImagePaths');
            return;
          }

          // Act
          final result = await pcvkService.batchPredict(testFiles);

          // Assert
          expect(result, isA<BatchPredictionResponse>());
          expect(result.predictions, isNotEmpty);
          expect(result.predictions.length, testFiles.length);
        },
        skip: false,
      );
    });
  });
}
