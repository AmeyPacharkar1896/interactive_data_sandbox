// frontend/lib/core/api_client.dart

import 'dart:convert';
import 'package:frontend/core/api_exception.dart';
import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async'; // Make sure this is imported
import 'dart:developer';

class ApiClient {
  final String _baseUrl;
  static ApiClient? _instance;

  // Increase timeout duration significantly for free tiers
  static const Duration _timeoutDuration = Duration(
    seconds: 90,
  ); // <-- INCREASED TIMEOUT

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

    log('FLUTTER DEBUG: Sending POST request to: $uri');
    log('FLUTTER DEBUG: Request Body: $encodedBody');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: encodedBody,
          )
          .timeout(_timeoutDuration); // Apply timeout here

      log('FLUTTER DEBUG: Received response from: $uri');
      log('FLUTTER DEBUG: Status Code: ${response.statusCode}');

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
    } on TimeoutException {
      throw ApiException(
        statusCode: -1,
        message:
            'Request timed out after $_timeoutDuration. The server might be spinning up or is slow.',
      );
    } catch (e) {
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
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(_timeoutDuration); // Apply timeout here

      log('FLUTTER DEBUG: Received response from: $uri');
      log('FLUTTER DEBUG: Status Code: ${response.statusCode}');

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
    } on TimeoutException {
      throw ApiException(
        statusCode: -1,
        message:
            'Request timed out after $_timeoutDuration. The server might be spinning up or is slow.',
      );
    } catch (e) {
      throw ApiException(
        statusCode: -1,
        message: 'An unexpected error occurred during API call: $e',
      );
    }
  }
}
