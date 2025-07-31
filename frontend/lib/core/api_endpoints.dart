// frontend\lib\core\api_endpoints.dart

class ApiEndpoints {
  static const String _apiV1 = '/api/v1';

  // Data Upload Endpoints
  static const String uploadCsv = '$_apiV1/data/upload-data';

  // EDA Endpoints (matching backend /api/v1/eda prefix)
  static const String getNumericalColumns = '$_apiV1/eda/numerical-columns';
  static const String generateScatterPlot = '$_apiV1/eda/scatter-plot';

  // ML Endpoints (matching backend /api/v1/ml prefix)
  static const String runKMeans = '$_apiV1/ml/kmeans';
}
