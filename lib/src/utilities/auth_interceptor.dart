import 'package:dio/dio.dart';

import '../common/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;

  AuthInterceptor(this.tokenService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token has expired
      try {
        await tokenService.refreshToken();
        // Retry the request
        final opts = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        );
        final clonedRequest = await Dio().request<dynamic>(
          err.requestOptions.path,
          options: opts,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        return handler.resolve(clonedRequest);
      } catch (e) {
        // If refresh fails, clear tokens and let the error propagate
        await tokenService.clearTokens();
      }
    }
    return super.onError(err, handler);
  }
}
