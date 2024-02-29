import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_path_coordinate_system/constants/constants.dart';

import '../../models/coordinates_model.dart';
import '../../repositories/coordinates_repository/base_coordinates_repository.dart';
import '../../utils/path_to_finding_the_shortest_path.dart';
import 'coordinates_state.dart';

class CoordinatesCubit extends Cubit<CoordinatesState> {
  CoordinatesCubit(this._repository) : super(CoordinatesInitial());

  final BaseCoordinatesRepository _repository;
  final String errorMessage = 'Set valid API base URL in order to continue';

  bool checkEnteredUrl({required String url}) {
    if (!url.contains(baseUrl)) {
      emit(ErrorCoordinates(errorMessage));
      return false;
    } else {
      return true;
    }
  }

  Future getCoordinates({required String url}) async {
    emit(CoordinatesLoading(isCheckProgress: true));

    try {
      final CoordinatesHelper helper = CoordinatesHelper();
      List<CoordinateModel> coordinates =
          await _repository.getCoordinates(url: url);

      for (int i = 0; i < coordinates.length; i++) {
        List<Map<String, int>> path = helper.findShortestPath(
            coordinates[i].field, coordinates[i].start, coordinates[i].end);
        coordinates[i].path = helper.formatCoordinatesList(path);

        if (coordinates[i].path != null) {
          List<Map<String, String>> steps =
              helper.formatSteps(coordinates[i].path!);

          coordinates[i].steps = steps;
        }
      }

      emit(CoordinatesLoading(isCheckProgress: false));

      await Future.delayed(const Duration(milliseconds: 500));

      emit(CoordinatesLoaded(coordinates));
    } catch (error) {
      emit(ErrorCoordinates(errorMessage));
    }
  }

  Future<bool> sendCoordinateResults(
      {required List<CoordinateModel> coordinates}) async {
    emit(SendingResultsIsLoading());

    try {
      await _repository.sendCoordinateResults(coordinates: coordinates);

      emit(SendingResultsIsLoaded());

      return true;
    } catch (error) {
      emit(ErrorSendingResult(error.toString()));
      return false;
    }
  }
}
