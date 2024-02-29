import 'package:short_path_coordinate_system/models/coordinates_model.dart';

abstract class BaseCoordinatesRepository {
  Future<List<CoordinateModel>> getCoordinates({required String url});
  Future sendCoordinateResults({required List<CoordinateModel> coordinates});
}
