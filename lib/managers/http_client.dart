import 'dart:io';

import 'package:affirm_assignment/managers/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String authHeader = 'itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx';

HttpManager httpManager = HttpManager._();  /// Global instance

/// Manager for making network calls. The client provided is authenticated with oauth token
class HttpManager {
  HttpManager._();

  Dio _client;

  Dio get client => _client;

  Future<void> init() async {
    _client = Dio()
      ..interceptors.addAll([
        _AuthInterceptor(),
        _ErrorInterceptor(),
        LogInterceptor(responseBody: kDebugMode)
      ]);
  }
}

class _AuthInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $authHeader';
    return super.onRequest(options);
  }
}

class _ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) {
    logger.e('Dio error: status code ${err?.response?.statusCode}, Path ${err?.request?.path}');
    /// TODO: We could add more error handling here
    return super.onError(err);
  }
}