import 'dart:developer';

import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout);
        _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        log('Dio Error: ${error.message}');
        log('Dio Error Response: ${error.response}');
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      return response;
    } on DioException catch (e) {
      log('DioException: $e');
      log('Response: ${e.response}');
      rethrow;
    } catch (e) {
      log('Unexpected error: $e');
      rethrow;
    }
  }
}