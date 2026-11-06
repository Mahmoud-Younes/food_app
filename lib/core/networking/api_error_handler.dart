import 'package:dio/dio.dart';

/// Converts network exceptions into friendly user messages.
String handleApiError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'No internet connection, please check your network and try again.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return 'Something went wrong, please try again.';
    }
  }
  return 'Something went wrong, please try again.';
}
