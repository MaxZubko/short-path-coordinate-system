import 'package:dio/dio.dart';

import '../enums/request_methods.dart';
import '../models/error_model.dart';

class HttpService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> request({
    required String url,
    required RequestMethods method,
    dynamic body,
  }) async {
    final Response response;
    try {
      if (method == RequestMethods.get) {
        response = await _dio.get(url);
      } else {
        response = await _dio.post(
          url,
          data: body,
        );
      }

      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        final message = ErrorModel.fromJson(error.response!.data);
        throw message.message;
      }
    } catch (error) {
      return error;
    }
  }
}
