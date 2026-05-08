import 'package:dio/dio.dart';
import '../auth/secure_storage.dart';
import '../error/exceptions.dart';
import 'endpoints.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorage _storage;

  ApiClient({
    required Dio dio,
    required SecureStorage storage,
  })  : _dio = dio,
        _storage = storage {
    _dio.options.baseUrl = Endpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      _RefreshInterceptor(_dio, _storage),
      _ErrorInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}

class _RefreshInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorage _storage;
  bool _isRefreshing = false;

  _RefreshInterceptor(this._dio, this._storage);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(Endpoints.refreshToken)) {
      if (_isRefreshing) {
        // Wait for current refresh to complete
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _storage.getRefreshToken();
        if (refreshToken == null) throw const AuthException('No refresh token');

        // Attempt refresh
        final response = await _dio.post(Endpoints.refreshToken, data: {'refresh_token': refreshToken});
        
        final newToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
        await _storage.saveToken(newToken);
        if (newRefreshToken != null) await _storage.saveRefreshToken(newRefreshToken);

        // Retry original request
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';
        
        final retryResponse = await _dio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        await _storage.deleteAll();
        // Here you would typically trigger a logout via an AuthBloc or similar
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;
    
    if (err.response != null) {
      // Normalize error message from server response
      final data = err.response?.data;
      message = data is Map ? (data['message'] ?? data['error'] ?? err.message) : err.message ?? 'Unknown error';
    } else {
      // Handle connection errors
      message = switch (err.type) {
        DioExceptionType.connectionTimeout => 'Connection timeout',
        DioExceptionType.sendTimeout => 'Send timeout',
        DioExceptionType.receiveTimeout => 'Receive timeout',
        DioExceptionType.cancel => 'Request cancelled',
        _ => 'Connection failed',
      };
    }

    // Pass normalized error
    return handler.next(err.copyWith(message: message));
  }
}
