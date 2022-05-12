import 'package:dio/dio.dart';

class DioContext {
  static final DioContext _dioContext = DioContext._internal();
  static final Dio _dio = Dio();

  DioContext._internal();

  static DioContext get() {
    return _dioContext;
  }

  static Dio getDio() {
    return _dio;
  }
}
