import 'package:dio/dio.dart';

import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio getDio() {
    final Dio dio = Dio();

    dio.options
      ..baseUrl = ApiConstants.apiBaseUrl
      ..responseType = ResponseType.json
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15);

    return dio;
  }
}
