import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/api_endpoints.dart';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/modules/ml/models/kmean_request_model.dart';
import 'package:frontend/modules/ml/models/kmean_response_model.dart';

class MLServices {
  final ApiClient _apiClient;
  static MLServices? _instance;

  MLServices._internal() : _apiClient = ApiClient();

  factory MLServices() {
    _instance ??= MLServices._internal();
    return _instance!;
  }

  Future<KMeansResponseModel> runKMeans(KMeansRequestModel request) async {
    try {
      final responseJson = await _apiClient.post(
        ApiEndpoints.runKMeans,
        request.toJson(),
      );
      return KMeansResponseModel.fromJson(responseJson);
    } on ApiException catch (e) {
      throw e;
    } catch (e) {
      throw Exception(
        'An unexpected error occurred during K-Means execution: ${e.toString()}',
      );
    }
  }
}
