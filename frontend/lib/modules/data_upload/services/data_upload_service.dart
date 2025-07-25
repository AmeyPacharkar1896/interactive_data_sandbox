// frontend\lib\modules\data_upload\services\data_upload_service.dart

import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_req_model.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_res_model.dart';

class DataUploadService {
  final ApiClient _apiClient;
  static DataUploadService? _instance;

  DataUploadService._internal()
    : _apiClient = ApiClient(baseUrl: kBackendBaseUrl);

  factory DataUploadService() {
    _instance ??= DataUploadService._internal();
    return _instance!;
  }
  Future<CsvUploadResModel> uploadCsvData(CsvUploadReqModel request) async {
    try {
      final responseJson = await _apiClient.post(
        '/api/v1/data/upload-data',
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
