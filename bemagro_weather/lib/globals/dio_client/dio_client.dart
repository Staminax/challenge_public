import 'package:dio/dio.dart';

final Dio DioClient = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    followRedirects: false,
    validateStatus: (status) {
      return status! < 500;
    },
  ),
);
