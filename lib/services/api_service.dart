import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_dtn/utils/constants.dart';
import 'package:app_dtn/services/token_service.dart';
import 'package:app_dtn/models/api_response.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final TokenService _tokenService = TokenService();

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Lấy headers cho API request
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    if (requiresAuth) {
      final token = await _tokenService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('Fetching URL: $uri');

      final response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  // Hàm xử lý response
  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Đảm bảo xử lý UTF-8 đúng cách
        final String responseBody = utf8.decode(response.bodyBytes);
        debugPrint('🔍 Response body: $responseBody');

        final jsonData = jsonDecode(responseBody);
        debugPrint('🔍 JSON structure type: ${jsonData.runtimeType}');

        // Xử lý trường hợp từng kiểu dữ liệu, tránh lỗi ép kiểu
        T? data;
        if (fromJson != null) {
          try {
            data = fromJson(jsonData);
          } catch (e) {
            debugPrint('❌ Error parsing JSON with fromJson: $e');
            return ApiResponse(
              success: false,
              message: 'Lỗi phân tích dữ liệu: ${e.toString()}',
              statusCode: response.statusCode,
            );
          }
        }

        return ApiResponse(
          success: true,
          message: 'Thành công',
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        String message;
        try {
          // Đảm bảo xử lý UTF-8 đúng cách
          final String responseBody = utf8.decode(response.bodyBytes);
          debugPrint('❌ Error response body: $responseBody');

          final jsonData = jsonDecode(responseBody);
          message = jsonData['message'] ?? 'Lỗi không xác định';
        } catch (e) {
          message = 'Lỗi: ${response.statusCode} - ${response.reasonPhrase}';
        }

        return ApiResponse(
          success: false,
          message: message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('❌ _processResponse error: $e');
      return ApiResponse(
        success: false,
        message: 'Lỗi xử lý phản hồi: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
