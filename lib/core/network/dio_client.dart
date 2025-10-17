import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nexera_task2/core/constants/app_constants.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('Making API request to: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('API response received: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        log('API error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
}