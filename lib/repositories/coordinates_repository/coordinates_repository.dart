import 'package:dio/dio.dart' as dio;
import 'package:short_path_coordinate_system/enums/request_methods.dart';
import 'package:short_path_coordinate_system/repositories/coordinates_repository/base_coordinates_repository.dart';

import '../../constants/constants.dart';
import '../../models/coordinates_model.dart';
import '../../services/http_service.dart';

class CoordinatesRepository implements BaseCoordinatesRepository {
  final HttpService _httpService = HttpService();

  @override
  Future<List<CoordinateModel>> getCoordinates({required String url}) async {
    final response = await _httpService.request(
      url: url,
      method: RequestMethods.get,
    );

    if (response == null) {
      return [];
    }

    if (response is dio.Response) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) {
        return CoordinateModel.fromJson(json);
      }).toList();
    } else if (response is String) {
      throw Exception(response);
    } else {
      return [];
    }
  }

  @override
  Future sendCoordinateResults(
      {required List<CoordinateModel> coordinates}) async {
    List<Map<String, dynamic>> data =
        coordinates.map((element) => element.toJson()).toList();

    await _httpService.request(
      url: '${baseUrl}flutter/api',
      method: RequestMethods.post,
      body: data,
    );
  }
}
