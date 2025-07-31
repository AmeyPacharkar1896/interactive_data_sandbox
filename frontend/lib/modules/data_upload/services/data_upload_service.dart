// frontend\lib\modules\data_upload\services\data_upload_service.dart

import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/api_endpoints.dart';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_req_model.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_res_model.dart';

class DataUploadService {
  final ApiClient _apiClient;
  static DataUploadService? _instance;

  DataUploadService._internal()
    : _apiClient = ApiClient();

  factory DataUploadService() {
    _instance ??= DataUploadService._internal();
    return _instance!;
  }
  Future<CsvUploadResModel> uploadCsvData(CsvUploadReqModel request) async {
    try {
      final responseJson = await _apiClient.post(
        ApiEndpoints.uploadCsv,
        request.toJson(),
      );
      return CsvUploadResModel.fromJson(responseJson);
    } on ApiException catch (e) {
      throw Exception('Failed to upload CSV: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during CSV upload: $e');
    }
  }
}
