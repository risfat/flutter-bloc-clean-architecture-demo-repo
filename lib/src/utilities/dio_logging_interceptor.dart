import 'package:dio/dio.dart';

import '../utilities/logger.dart';

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.info('┌─────────────────── Request ───────────────────');
    logger.info('│ ${options.method} ${options.uri}');
    logger.info('│ Headers:');
    options.headers.forEach((key, value) {
      logger.info('│   $key: $value');
    });
    if (options.data != null) {
      logger.info('│ Body: ${options.data}');
    }
    logger.info('└─────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.info('┌─────────────────── Response ──────────────────');
    logger.info('│ ${response.statusCode} ${response.statusMessage}');
    logger.info('│ Data:');
    _logData(response.data);
    logger.info('└─────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.error('┌─────────────────── Error ────────────────────');
    logger.error('│ ${err.message}');
    if (err.response != null) {
      logger.error(
          '│ ${err.response?.statusCode} ${err.response?.statusMessage}');
      logger.error('│ Data:');
      _logData(err.response?.data);
    }
    logger.error('└─────────────────────────────────────────────');
    super.onError(err, handler);
  }

  void _logData(dynamic data) {
    if (data is Map) {
      data.forEach((key, value) {
        logger.info('│   $key: $value');
      });
    } else if (data is List) {
      for (var i = 0; i < data.length; i++) {
        logger.info('│   [$i]: ${data[i]}');
      }
    } else {
      logger.info('│   $data');
    }
  }
}
