// frontend\lib\core\api_exception.dart

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? responseBody;

  ApiException({
    required this.statusCode,
    required this.message,
    this.responseBody,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)\nResponse: $responseBody';
  }
}
