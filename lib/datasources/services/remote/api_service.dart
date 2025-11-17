import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../models/base_response.dart';
import '../local/local_storage_service.dart';

abstract class ApiService {
  Future<BaseResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic json) fromJson,
    Function(dynamic json)? rawJson,
  });
  Future<BaseResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  });
  Future<BaseResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  });
  Future<BaseResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  });
}

class ApiServiceImpl implements ApiService {
  final Dio _dio;
  final String logUrl;
  ApiServiceImpl(
    String baseUrl, {
    required this.logUrl,
    // Duration connectTimeout = const Duration(seconds: 5),
    // Duration receiveTimeout = const Duration(seconds: 3),
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            // connectTimeout: connectTimeout,
            // receiveTimeout: receiveTimeout,
          ),
        ) {
    _initializeHeaders();
  }

  void _initializeHeaders() {
    _dio.options.headers.addAll({
      'accept': 'application/json; charset=utf-8',
      'content-type': 'application/json',
      'accept-type': 'application/json',
      'accept-language':
          (LocalStorageServices.getData(LocalStorageKey.language).isEmpty
              ? 'mm'
              : LocalStorageServices.getData(LocalStorageKey.language)),
      "API-KEY": ApiSecurityKeyService.getApiKey()
    });
  }

  @override
  Future<BaseResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic json) fromJson,
    Function(dynamic json)? rawJson,
  }) async {
    return _safeApiCall(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _buildHeaders(headers)),
      ),
      fromJson,
      path,
      rawJson: rawJson,
    );
  }

  @override
  Future<BaseResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeApiCall(
      () => _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: _buildHeaders(headers)),
      ),
      fromJson,
      path,
    );
  }

  @override
  Future<BaseResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeApiCall(
      () => _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: _buildHeaders(headers)),
      ),
      fromJson,
      path,
    );
  }

  @override
  Future<BaseResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeApiCall(
      () => _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: _buildHeaders(headers)),
      ),
      fromJson,
      path,
    );
  }

  Map<String, dynamic> _buildHeaders(Map<String, dynamic>? headers) {
    final token = LocalStorageServices.getData(LocalStorageKey.token);
    return {
      ...?headers,
      if (token.isNotEmpty) 'authorization': 'Bearer $token',
    };
  }

  Future<BaseResponse<T>> _safeApiCall<T>(
    Future<Response> Function() request,
    T Function(dynamic json) fromJson,
    String path, {
    Function(dynamic json)? rawJson,
  }) async {
    try {
      final response = await request();

      try {
        final responseData = _handleResponse(response);

        // If rawJson is provided, call it with the response data
        if (rawJson != null) {
          rawJson(responseData);
        }

        return BaseResponse.fromJson(
          responseData,
          fromJson,
        );
      } catch (e, stack) {
        print('Deserialization error in $path: $e\nData: $stack ');
        await _sendErrorLogToServer(
          path: path,
          errorType: 'DeserializationError',
          error: e.toString(),
          responseData: response.data.toString(),
        );

        return BaseResponse(
          success: false,
          msg: 'Deserialization error in $path: $e\nData: $stack ',
          data: null,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        await _sendErrorLogToServer(
          path: path,
          errorType: 'ServerError',
          error: e.toString(),
          responseData: e.response?.data.toString(),
        );
      }
      return BaseResponse(
        success: false,
        msg: _handleDioError(e, path).toString(),
        data: null,
      );
    } catch (e) {
      return BaseResponse(
        success: false,
        msg: 'An unexpected error occurred: $e',
        data: null,
      );
    }
  }

  // Response handling
  _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 400) {
      return response.data;
    } else {
      throw ApiException(
        message: 'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  // Error handling
  Exception _handleDioError(DioException error, String path) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timed out',
          statusCode: 408,
          path: path,
        );

      case DioExceptionType.badResponse:
        String errorMessage =
            'Server returned an error: ${error.response?.statusCode}';

        if (error.response?.data != null) {
          final responseData = error.response!.data;

          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message'] ??
                responseData['error'] ??
                responseData['msg'] ??
                errorMessage;
          } else if (responseData is String) {
            // String response - try to parse as JSON
            try {
              final Map<String, dynamic> jsonData = jsonDecode(responseData);
              errorMessage = jsonData['message'] ??
                  jsonData['error'] ??
                  jsonData['msg'] ??
                  responseData; // Use the raw string if no message field found
            } catch (e) {
              // If JSON parsing fails, use the raw string
              errorMessage = responseData;
            }
          } else {
            errorMessage = responseData.toString();
          }
        }

        return ApiException(
          message: errorMessage,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection',
          statusCode: null,
          path: path,
        );

      default:
        return ApiException(
          message: 'An error occurred: ${error.message}',
          statusCode: null,
          path: path,
        );
    }
  }

  Future<void> _sendErrorLogToServer({
    required String path,
    required String errorType,
    required String error,
    required String? responseData,
  }) async {
    try {
      await _dio.post(
        logUrl, // Change to your log endpoint
        data: {
          'path': path,
          'errorType': errorType,
          'error': error,
          'responseData': responseData,
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'content-type': 'application/json'},
        ),
      );
    } catch (e) {
      // Optionally print or handle logging failure
      print('Failed to send error log: $e');
    }
  }

  // Cleanup
  void dispose() {
    _dio.close();
  }
}

// Custom exception class

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? path; // Add this

  ApiException({required this.message, this.statusCode, this.path});

  @override
  String toString() {
    print('ApiException: $message (Status: $statusCode, Path: $path)');
    return message;
  }
}

class ApiSecurityKeyService {
  static String getApiKey() {
    const apiString = 'bff-api-security';
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDate);
    final dataToEncrypt = '$apiString/$formattedDate';
    final encrypter = Encrypter(RSA(publicKey: _getPublicKey()));
    final encrypted = encrypter.encrypt(dataToEncrypt);
    return encrypted.base64;
  }

  static RSAPublicKey _getPublicKey() {
    const pem =
        '''-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsviycg2tzIf5lxMW1gWN\ndzTkeGK5pkheVSNHqxZPJu1dfoeLIOgNUQA1DuFr02oE6u5FuVthosBnxb/bmB08\nMzde6ocb1vtaP5KTCY1DmOnZ/Vw64NeDBnqNJn0feKotvk2pWZGThoHIsFApuM4/\n4gN8lWih6iQFvLfBdNcobyzADEZkQ2dHJay8sDTKgEqFQ3L+TGuj4Zzgs+nvIy+t\nQkTK72DHFY33NZz1BLQXHo0mPfO3nClkAeKaKQ4i/DuVBX/hSbbNgPVrXfmeRv54\nn4yrR1FG1gFLoapYDM6IDKtJUi19Mh8IAwuBtqkV4aTSHLg8BqjFHfxbbqIHNBLu\nfwIDAQAB\n-----END PUBLIC KEY-----''';

    final parser = RSAKeyParser();
    final publicKey = parser.parse(pem) as RSAPublicKey;
    return publicKey;
  }
}
