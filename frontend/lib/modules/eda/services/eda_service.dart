// frontend/lib/modules/eda/services/eda_service.dart

import 'dart:developer';

import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/api_endpoints.dart';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/modules/eda/models/numerical_column_response_model.dart';
import 'package:frontend/modules/eda/models/scatterplot_request_model.dart';
import 'package:frontend/modules/eda/models/scatterplot_response_model.dart'; // Import for log

class EdaService {
  final ApiClient _apiClient;
  static EdaService? _instance;

  EdaService._internal() : _apiClient = ApiClient();

  factory EdaService() {
    _instance ??= EdaService._internal();
    return _instance!;
  }

  Future<NumericalColumnResponseModel> getNumericalColumns(
    String datasetId,
  ) async {
    try {
      final responseJson = await _apiClient.get(
        '${ApiEndpoints.getNumericalColumns}/$datasetId',
      );
      // --- NEW DEBUG LOG ---
      log(
        'EDA SERVICE: Raw JSON response for numerical columns: $responseJson',
      );
      // --- END NEW DEBUG LOG ---
      return NumericalColumnResponseModel.fromJson(responseJson);
    } on ApiException catch (e) {
      throw e;
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching numerical columns: ${e.toString()}',
      );
    }
  }

  Future<ScatterPlotResponseModel> generateScatterPlot(
    ScatterPlotRequestModel request,
  ) async {
    try {
      final responseJson = await _apiClient.post(
        ApiEndpoints.generateScatterPlot,
        request.toJson(),
      );
      return ScatterPlotResponseModel.fromJson(responseJson);
    } on ApiException catch (e) {
      throw e;
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while generating scatter plot: ${e.toString()}',
      );
    }
  }
}
