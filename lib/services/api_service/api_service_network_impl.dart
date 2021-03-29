import 'package:dashboard/core/exceptions/network_exception.dart';
import 'package:dashboard/services/api_service/api_request.dart';
import 'package:dashboard/services/api_service/api_service.dart';
import 'package:dashboard/services/session_manager/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const DEFAULT_CONNECTION_TIMEOUT = Duration(seconds: 10);
const DEFAULT_RECEIVE_TIMEOUT = Duration(seconds: 10);
const LOGIN_ROUTE = "auth/login";
const REFRESH_ACCESS_TOKEN_ROUTE = "auth/refresh";

class APIServiceNetworkImpl implements APIService {
  static BaseOptions options = BaseOptions(
    baseUrl: 'https://api-dev.kundapi.ch/api/v1/',
    // baseUrl: 'http://172.22.90.70:8080/api/v1/',
    // baseUrl: 'http://10.0.2.2:53310/api/v1/',
    // baseUrl: 'http://10.0.2.2:8080/api/v1/',
    connectTimeout: DEFAULT_CONNECTION_TIMEOUT.inMilliseconds,
    receiveTimeout: DEFAULT_RECEIVE_TIMEOUT.inMilliseconds,
  );

  SessionManager prefs = SessionManager();

  final Dio _dio = getApiClient(options);

  @override
  Future<bool> isAPIavailable() async {
    try {
      await _dio.get('healthz');
      // Logger.d('API is available');
      return true;
    } catch (e) {
      // Logger.d('API is not available');
      return false;
    }
  }

  @override
  Future<dynamic> get(APIRequest apiRequest) async {
    try {
      final response = await _dio.get(
        apiRequest.uri,
        queryParameters: apiRequest.queryParameters,
        options: apiRequest.options,
        cancelToken: apiRequest.cancelToken,
        onReceiveProgress: apiRequest.onReceiveProgress,
      );
      return response.data;
    } on DioError catch (e) {
      exceptionHandling(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(APIRequest apiRequest) async {
    try {
      final response = await _dio.post(
        apiRequest.uri,
        data: apiRequest.data,
        queryParameters: apiRequest.queryParameters,
        options: apiRequest.options,
        cancelToken: apiRequest.cancelToken,
        onSendProgress: apiRequest.onSendProgress,
        onReceiveProgress: apiRequest.onReceiveProgress,
      );
      return response.data;
    } on DioError catch (e) {
      exceptionHandling(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future delete(APIRequest apiRequest) async {
    try {
      final response = await _dio.delete(
        apiRequest.uri,
        data: apiRequest.data,
        queryParameters: apiRequest.queryParameters,
        options: apiRequest.options,
        cancelToken: apiRequest.cancelToken,
      );
      return response.data;
    } on DioError catch (e) {
      exceptionHandling(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future update(APIRequest apiRequest) async {
    try {
      final response = await _dio.put(
        apiRequest.uri,
        data: apiRequest.data,
        queryParameters: apiRequest.queryParameters,
        options: apiRequest.options,
        cancelToken: apiRequest.cancelToken,
        onSendProgress: apiRequest.onSendProgress,
        onReceiveProgress: apiRequest.onReceiveProgress,
      );
      return response.data;
    } on DioError catch (e) {
      exceptionHandling(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future patch(APIRequest apiRequest) async {
    try {
      final response = await _dio.patch(
        apiRequest.uri,
        data: apiRequest.data,
        queryParameters: apiRequest.queryParameters,
        options: apiRequest.options,
        cancelToken: apiRequest.cancelToken,
        onSendProgress: apiRequest.onSendProgress,
        onReceiveProgress: apiRequest.onReceiveProgress,
      );
      return response.data;
    } on DioError catch (e) {
      exceptionHandling(e);
    } catch (e) {
      rethrow;
    }
  }
}

Dio getApiClient(BaseOptions options) {
  // const storage = fss.FlutterSecureStorage();
  // SharedPreferences prefs = SharedPreferences.getInstance();
  SessionManager prefs = SessionManager();

  // Initiate Dio client
  final _dio = Dio(options);

  if (kDebugMode) {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
      ),
    );
  }

  // Add the interceptors
  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.contentType = 'application/json';
        // final accessToken = await storage.read(key: 'accessToken');
        final accessToken = await prefs.getString('accessToken');

        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
      },
      onError: (DioError dioError, ErrorInterceptorHandler handler) async {
        // If request was login then skip error handling
        if (dioError.requestOptions.path == LOGIN_ROUTE) {
          return null;
        }

        // If accessToken was revoked refresh token
        if (dioError.response?.statusCode == 401) {
          final response = await refreshAccessToken(dioError, _dio, prefs);

          if (response.statusCode == 200) {
            setNewTokens(response, dioError, _dio, prefs);
          }
        }
        return null;
      },
    ),
  );

  return _dio;
}

Future<Response<dynamic>> refreshAccessToken(
    DioError dioError, Dio dio, SessionManager prefs) async {
  // Logger.d('Access token expired. Trying to refresh the access token.');

  // await storage.delete(key: 'accessToken'); // Delete expired token
  prefs.remove('accessToken');
  final refreshToken = prefs.getString('refreshToken');
  // final refreshToken = await storage.read(key: 'refreshToken');
  final data = <String, dynamic>{
    "GrantType": "RefreshToken",
  };

  // final options = RequestOptions(path: REFRESH_ACCESS_TOKEN_ROUTE);
  final options = Options();
  options.headers?["Authorization"] = "Bearer $refreshToken";

  final Response<dynamic> response = await dio.post(
    REFRESH_ACCESS_TOKEN_ROUTE,
    data: data,
    options: options,
  );

  return response;
}

Future setNewTokens(
  Response<dynamic> response,
  DioError dioError,
  Dio dio,
  // fss.FlutterSecureStorage storage,
  SessionManager prefs,
) async {
  final newRefreshToken = response.data["RefreshToken"] as String;
  final newAccessToken = response.data["AccessToken"] as String;

  // storage.write(key: 'refreshToken', value: newRefreshToken);
  // storage.write(key: 'accessToken', value: newAccessToken);
  prefs.setString('refreshToken', newRefreshToken);
  prefs.setString('accessToken', newAccessToken);

  // Logger.d('Refreshing the access token successful.');

  // Retry request with new access token
  return dio
      .request(dioError.requestOptions.baseUrl + dioError.requestOptions.path);
}

void exceptionHandling(DioError e) {
  switch (e.type) {
    case DioErrorType.response:
      switch (e.response?.statusCode) {
        case 401:
        case 403:
          throw const NetworkException("not authorized");
        case 404:
          throw const ResourceNotFoundException("resource not found");
        case 500:
        case 501:
        case 502:
        case 503:
          throw const ServerException("server error");
      }
      throw const NetworkException('general exception');
    case DioErrorType.connectTimeout:
      throw const TimeoutException("connection timeout");
    case DioErrorType.sendTimeout:
      throw const TimeoutException("send timeout");
    case DioErrorType.receiveTimeout:
      throw const TimeoutException("receive timeout");
    case DioErrorType.cancel:
      throw const RequestCanceledException("request canceled");
    case DioErrorType.other:
      throw NetworkException(e.error.toString());
  }
}
