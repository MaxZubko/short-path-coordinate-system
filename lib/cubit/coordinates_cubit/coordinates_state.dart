import '../../models/coordinates_model.dart';

sealed class CoordinatesState {}

final class CoordinatesInitial extends CoordinatesState {}

final class CoordinatesLoading extends CoordinatesState {
  final bool isCheckProgress;

  CoordinatesLoading({
    this.isCheckProgress = false,
  });
}

final class CoordinatesLoaded extends CoordinatesState {
  final List<CoordinateModel> coordinates;

  CoordinatesLoaded(this.coordinates);
}

final class ErrorCoordinates extends CoordinatesState {
  final String error;

  ErrorCoordinates(this.error);
}

final class SendingResultsIsLoading extends CoordinatesState {}

final class SendingResultsIsLoaded extends CoordinatesState {}

final class ErrorSendingResult extends CoordinatesState {
  final String error;

  ErrorSendingResult(this.error);
}
