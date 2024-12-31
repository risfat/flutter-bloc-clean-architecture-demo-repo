import 'package:dio/dio.dart';

import '../utilities/dio_logging_interceptor.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDioInstance();
    return _instance!;
  }

  static Dio _createDioInstance() {
    final dio = Dio();
    // final tokenService = TokenService(dio);
    //
    // // Add AuthInterceptor
    // dio.interceptors.add(AuthInterceptor(tokenService));

    // Add DioLoggingInterceptor
    dio.interceptors.add(DioLoggingInterceptor());

    return dio;
  }
}
