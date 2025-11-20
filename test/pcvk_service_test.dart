import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jawara/core/models/PCVK/batch_predict_response.dart';
import 'package:jawara/core/models/PCVK/health_response.dart';
import 'package:jawara/core/models/PCVK/models_response.dart';
import 'package:jawara/core/models/PCVK/predict_response.dart';
import 'package:jawara/core/services/pcvk_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pcvk_service_test.mocks.dart';
import 'fixtures/pcvk_mock_responses.dart';

@GenerateMocks([http.Client])
void main() {
  group('PcvkService', () {
    late PcvkService pcvkService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      pcvkService = PcvkService(httpClient: mockClient);
    });

    group('getHealth', () {
      test('returns HealthModelResponse on successful response', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(PcvkMockResponses.healthSuccess), 200),
        );

        // Act
        final result = await pcvkService.getHealth();

        // Assert
        expect(result, isA<HealthModelResponse>());
        expect(result.status, 'healthy');
        expect(result.device, 'cpu');
        expect(result.numClasses, 4);
        expect(result.classNames, [
          'Sayur Akar',
          'Sayur Buah',
          'Sayur Daun',
          'Sayur Polong',
        ]);
        expect(result.availableModels, ['mlp', 'mlpv2', 'mlpv2_auto-clahe']);

        verify(mockClient.get(any)).called(1);
      });

      test('throws exception on failed response', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => pcvkService.getHealth(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch health - 404'),
            ),
          ),
        );

        verify(mockClient.get(any)).called(1);
      });

      test('throws exception on server error', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        // Act & Assert
        expect(
          () => pcvkService.getHealth(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch health - 500'),
            ),
          ),
        );
      });
    });

    group('getClasses', () {
      test('returns list of classes on successful response', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(PcvkMockResponses.classesSuccess), 200),
        );

        // Act
        final result = await pcvkService.getClasses();

        // Assert
        expect(result, isA<List<String>>());
        expect(result, [
          "Sayur Akar",
          "Sayur Buah",
          "Sayur Daun",
          "Sayur Polong",
        ]);
        expect(result.length, 4);

        verify(mockClient.get(any)).called(1);
      });

      test('throws exception on failed response', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Bad Request', 400));

        // Act & Assert
        expect(
          () => pcvkService.getClasses(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch classes - 400'),
            ),
          ),
        );
      });
    });

    group('getModels', () {
      test('returns ModelsModelResponse on successful response', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(PcvkMockResponses.modelsSuccess), 200),
        );

        // Act
        final result = await pcvkService.getModels();

        // Assert
        expect(result, isA<ModelsModelResponse>());
        expect(result.totalModels, 4);
        expect(result.availableModels, ['mlp', 'mlpv2', 'mlpv2_auto-clahe']);
        expect(result.models['mlp']!.loaded, true);
        expect(result.models['mlp']!.architecture, 'Simple MLP');
        expect(result.models['mlp']!.hiddenLayers, '512 -> 256');
        expect(result.models['mlp']!.dropout, 0.5);
        expect(result.models['mlp']!.features, ['Simple Linear Layers']);

        verify(mockClient.get(any)).called(1);
      });

      test('handles null optional fields', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(
            json.encode(PcvkMockResponses.modelsNullFields),
            200,
          ),
        );

        // Act
        final result = await pcvkService.getModels();

        // Assert
        expect(result.totalModels, 1);
        expect(result.models['u2netp']!.loaded, false);
        expect(result.models['u2netp']!.architecture, null);
        expect(result.models['u2netp']!.hiddenLayers, null);
        expect(result.models['u2netp']!.dropout, 0.0);
        expect(result.models['u2netp']!.features, null);
      });
    });

    group('predict', () {
      late File mockFile;

      setUp(() async {
        // Create a temporary test file
        mockFile = File('test_image.jpg');
        await mockFile.writeAsBytes([0, 1, 2, 3]); // Create dummy file
      });

      tearDown(() async {
        // Clean up test files
        if (await mockFile.exists()) {
          await mockFile.delete();
        }
      });

      test('returns PredictModelResponse on successful prediction', () async {
        // Arrange
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(
              utf8.encode(json.encode(PcvkMockResponses.predictSuccess)),
            ),
            200,
          ),
        );

        // Act
        final result = await pcvkService.predict(mockFile);

        // Assert
        expect(result, isA<PredictModelResponse>());
        expect(result.toJson(), {
          "filename": "test_image.jpg",
          "predicted_class": "Sayur Akar",
          "confidence": 0.9371846914291382,
          "all_confidences": {
            "Sayur Akar": 0.9371846914291382,
            "Sayur Buah": 0.031748250126838684,
            "Sayur Daun": 0.024870024994015694,
            "Sayur Polong": 0.006197091657668352,
          },
          "device": "cpu",
          "model_type": "mlpv2_auto-clahe",
          "segmentation_used": true,
          "segmentation_method": "u2netp",
          "apply_brightness_contrast": true,
        });

        verify(mockClient.send(any)).called(1);
      });

      test('throws exception on failed prediction', () async {
        // Arrange
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(utf8.encode('Bad Request')),
            400,
          ),
        );

        // Act & Assert
        expect(
          () => pcvkService.predict(mockFile),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to predict - 400'),
            ),
          ),
        );
      });

      test('throws exception on server error during prediction', () async {
        // Arrange
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(utf8.encode('Internal Server Error')),
            500,
          ),
        );

        // Act & Assert
        expect(
          () => pcvkService.predict(mockFile),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to predict - 500'),
            ),
          ),
        );
      });
    });

    group('batchPredict', () {
      late List<File> mockFiles;

      setUp(() async {
        // Create temporary test files
        mockFiles = [
          File('test_image1.jpg'),
          File('test_image2.jpg'),
          File('test_image3.jpg'),
        ];

        // Create dummy files
        for (var file in mockFiles) {
          await file.writeAsBytes([0, 1, 2, 3]);
        }
      });

      tearDown(() async {
        // Clean up test files
        for (var file in mockFiles) {
          if (await file.exists()) {
            await file.delete();
          }
        }
      });

      test(
        'returns BatchPredictionResponse on successful batch prediction',
        () async {
          // Arrange
          when(mockClient.send(any)).thenAnswer(
            (_) async => http.StreamedResponse(
              Stream.value(
                utf8.encode(json.encode(PcvkMockResponses.batchPredictSuccess)),
              ),
              200,
            ),
          );

          // Act
          final result = await pcvkService.batchPredict(mockFiles);

          // Assert
          expect(result, isA<BatchPredictionResponse>());
          expect(result.predictions.length, 2);

          // First result
          expect(result.predictions[0].predictedClass, 'Sayur Akar');
          expect(result.predictions[0].confidence, 0.9439828395843506);
          expect(
            result.predictions[0].allConfidences['Sayur Akar'],
            0.9439828395843506,
          );
          expect(result.predictions[0].device, 'cpu');
          expect(result.predictions[0].modelType, 'mlpv2_auto-clahe');
          expect(result.predictions[0].error, null);

          // Second result
          expect(result.predictions[1].predictedClass, 'Sayur Buah');
          expect(result.predictions[1].confidence, 0.7061872482299805);
          expect(
            result.predictions[1].allConfidences['Sayur Buah'],
            0.7061872482299805,
          );

          verify(mockClient.send(any)).called(1);
        },
      );

      test('handles batch prediction with error', () async {
        // Arrange
        when(mockClient.send(any)).thenAnswer(
          (_) async => http.StreamedResponse(
            Stream.value(
              utf8.encode(json.encode(PcvkMockResponses.batchPredictError)),
            ),
            200,
          ),
        );

        // Act
        final result = await pcvkService.batchPredict(mockFiles);

        // Assert
        expect(result, isA<BatchPredictionResponse>());
        expect(result.predictions.length, 2);

        // First result
        expect(result.predictions[0].predictedClass, 'Sayur Akar');
        expect(result.predictions[0].confidence, 0.9439828395843506);
        expect(
          result.predictions[0].allConfidences['Sayur Akar'],
          0.9439828395843506,
        );
        expect(result.predictions[0].device, 'cpu');
        expect(result.predictions[0].modelType, 'mlpv2_auto-clahe');
        expect(result.predictions[0].error, null);

        // Second result
        expect(result.predictions[1].fileName, '12313clipboard.png');
        expect(result.predictions[1].error, "Fail");

        verify(mockClient.send(any)).called(1);
      });
    });

    group('Error handling', () {
      test('handles network errors gracefully', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenThrow(const SocketException('Network unreachable'));

        // Act & Assert
        expect(() => pcvkService.getHealth(), throwsA(isA<SocketException>()));
      });

      test('handles timeout errors', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenThrow(TimeoutException('Request timeout'));

        // Act & Assert
        expect(
          () => pcvkService.getClasses(),
          throwsA(isA<TimeoutException>()),
        );
      });
    });
  });
}
