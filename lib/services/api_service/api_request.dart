import 'package:dio/dio.dart';

class APIRequest {
  String uri;
  Map<String, dynamic>? data;
  Map<String, dynamic>? queryParameters;
  Options? options;
  CancelToken? cancelToken;
  ProgressCallback? onSendProgress;
  ProgressCallback? onReceiveProgress;

  APIRequest(
    this.uri, {
    this.data,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
  });
}
