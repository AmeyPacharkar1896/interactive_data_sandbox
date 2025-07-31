// frontend/lib/core/api_client.dart

import 'dart:convert';
import 'dart:developer';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // Required for SocketException

class ApiClient {
  final String _baseUrl;
  static ApiClient? _instance;

  ApiClient._internal({required String baseUrl}) : _baseUrl = baseUrl;

  factory ApiClient() {
    _instance ??= ApiClient._internal(baseUrl: kBackendBaseUrl);
    return _instance!;
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$_baseUrl$path');
    final encodedBody = json.encode(body);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: encodedBody,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          // If JSON decoding fails, provide a clear error message
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid JSON response from server. Error: $e',
            responseBody: response.body,
          );
        }
      } else {
        // Handle non-2xx status codes
        // Ensure reasonPhrase is not null
        final String reason = response.reasonPhrase ?? 'Unknown error';
        throw ApiException(
          statusCode: response.statusCode,
          message: 'HTTP Error: ${response.statusCode} - $reason',
          responseBody: response.body,
        );
      }
    } on SocketException {
      // No internet connection or host unreachable
      throw ApiException(
        statusCode: -1,
        message: 'No Internet connection. Please check your network.',
      );
    } on http.ClientException catch (e) {
      // General HTTP client errors
      throw ApiException(
        statusCode: -1,
        message: 'Client exception during HTTP request: ${e.message}',
      );
    } catch (e) {
      // Catch any other unexpected errors during the HTTP call
      throw ApiException(
        statusCode: -1,
        message: 'An unexpected error occurred during API call: $e',
      );
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');

    log('FLUTTER DEBUG: Sending GET request to: $uri');
    try {
      final response = await http.get(
        uri,
        headers: {'Context-Type': 'application/json'},
      );

      log('FLUTTER DEBUG: Received response from: $uri');
      log('FLUTTER DEBUG: Status Code: ${response.statusCode}');
      log('FLUTTER DEBUG: Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Invalid JSON response from server. Error: $e',
            responseBody: response.body,
          );
        }
      } else {
        final String reason = response.reasonPhrase ?? 'Unknown error';
        throw ApiException(
          statusCode: response.statusCode,
          message: 'HTTP Error: ${response.statusCode} - $reason',
          responseBody: response.body,
        );
      }
    } on SocketException {
      throw ApiException(
        statusCode: -1,
        message: 'No Internet connection. Please check your network.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: -1,
        message: 'Client exception during HTTP request: ${e.message}',
      );
    } catch (e) {
      throw ApiException(
        statusCode: -1,
        message: 'An unexpected error occurred during API call: $e',
      );
    }
  }

  // TODO: Add PUT, DELETE as needed
}
