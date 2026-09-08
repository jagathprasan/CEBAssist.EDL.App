import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Thin HTTP helper for the CEBAssist API aggregator.
class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl, String? companyId})
    : _http = httpClient ?? http.Client(),
      baseUrl = (baseUrl ?? AppConfig.apiBaseUrl).replaceAll(RegExp(r'/$'), ''),
      companyId = companyId ?? AppConfig.companyId;

  final http.Client _http;
  final String baseUrl;
  final String companyId;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers({String? accessToken}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    return _send(
      () => _http
          .post(
            _uri(path),
            headers: _headers(accessToken: accessToken),
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(AppConfig.requestTimeout),
    );
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    String? accessToken,
  }) async {
    return _send(
      () => _http
          .get(_uri(path), headers: _headers(accessToken: accessToken))
          .timeout(AppConfig.requestTimeout),
    );
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();
      final payload = _decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return payload ?? <String, dynamic>{};
      }

      throw ApiException(
        _errorMessage(payload, response.statusCode),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException(
        'Unable to reach CEBAssist. Check your connection and try again.',
      );
    } on HttpException {
      throw const ApiException(
        'Unable to reach CEBAssist. Check your connection and try again.',
      );
    } on FormatException {
      throw const ApiException('The server returned an unexpected response.');
    } on HandshakeException {
      throw const ApiException(
        'Secure connection to CEBAssist failed. Please try again later.',
      );
    } on TlsException {
      throw const ApiException(
        'Secure connection to CEBAssist failed. Please try again later.',
      );
    } on TimeoutException {
      throw const ApiException(
        'CEBAssist took too long to respond. Please try again.',
      );
    } catch (error) {
      throw const ApiException(
        'Unable to complete this request. Please try again.',
      );
    }
  }

  Map<String, dynamic>? _decode(String body) {
    if (body.trim().isEmpty) return null;
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }

  String _errorMessage(Map<String, dynamic>? payload, int statusCode) {
    final server =
        payload?['error'] ?? payload?['Error'] ?? payload?['message'];
    if (server is String && server.trim().isNotEmpty) {
      return server.trim();
    }

    if (statusCode == 401) {
      return 'Invalid username or password.';
    }
    if (statusCode == 403) {
      return 'This account is not authorized for the ${AppConfig.companyName} workspace.';
    }
    if (statusCode == 423) {
      return 'This account is temporarily locked. Try again later or contact your administrator.';
    }
    return 'We could not complete sign-in. Please try again.';
  }
}
