// frontend/lib/core/api_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:frontend/core/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  static ApiClient? _instance;

  ApiClient._internal({required this.baseUrl});

  factory ApiClient({required String baseUrl}) {
    _instance ??= ApiClient._internal(baseUrl: baseUrl);
    return _instance!;
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid JSON response',
            responseBody: response.body,
          );
        }
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Error: ${response.statusCode} - ${response.reasonPhrase}',
          responseBody: response.body,
        );
      }
    } on SocketException {
      throw ApiException(statusCode: -1, message: 'No Internet connection');
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: -1,
        message: 'Client exception: ${e.message}',
      );
    } catch (e) {
      throw ApiException(statusCode: -1, message: 'Unexpected error: $e');
    }
  }

  // TODO: Add GET, PUT, DELETE as needed
}
