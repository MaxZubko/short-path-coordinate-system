import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_path_coordinate_system/features/result_screen/result_screen.dart';
import 'package:short_path_coordinate_system/widgets/default_button.dart';

import '../../cubit/coordinates_cubit/coordinates_cubit.dart';
import '../../cubit/coordinates_cubit/coordinates_state.dart';
import '../../models/coordinates_model.dart';

class ProcessScreenBody extends StatefulWidget {
  const ProcessScreenBody({super.key});

  @override
  State<ProcessScreenBody> createState() => _ProcessScreenBodyState();
}

class _ProcessScreenBodyState extends State<ProcessScreenBody> {
  final StreamController<int> _progressStreamController =
      StreamController<int>.broadcast();
  Timer? _timer;
  int _counter = 0;
  bool _timerRunning = false;

  List<CoordinateModel> coordinatesList = [];

  final TextStyle textStyle = const TextStyle(
    fontSize: 20,
  );

  @override
  void dispose() {
    _progressStreamController.close();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_timerRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        if (_counter < 100) {
          _counter++;
          _progressStreamController.sink.add(_counter);
        } else {
          _timer?.cancel();
          _timerRunning = false;
          _progressStreamController.close();
        }
      });
      _timerRunning = true;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timerRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoordinatesCubit, CoordinatesState>(
      listener: (context, state) {
        if (state is ErrorCoordinates) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final CoordinatesCubit cubit =
            BlocProvider.of<CoordinatesCubit>(context);

        bool isLoadingCoordinates = false;
        bool isLoadedCoordinates = false;
        bool isSendingResultsLoading = false;
        bool isErrorSendingResult = false;
        bool isDisableBtn = false;
        String errorMessage = '';

        if (state is CoordinatesLoading) {
          isLoadingCoordinates = true;

          if (state.isCheckProgress) {
            _startTimer();
          } else {
            _stopTimer();
          }
        }

        if (state is CoordinatesLoaded) {
          coordinatesList = state.coordinates;
          isLoadedCoordinates = true;
        }

        if (state is SendingResultsIsLoading) {
          isDisableBtn = true;
          isSendingResultsLoading = true;
        }

        if (state is ErrorSendingResult) {
          isErrorSendingResult = true;
          errorMessage = state.error;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              if (isLoadingCoordinates) ...[
                StreamBuilder<int>(
                    stream: _progressStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data}%');
                      } else {
                        return const Text('0%');
                      }
                    }),
                const SizedBox(height: 15),
                _progressIndicator(),
              ],
              if (isLoadedCoordinates) ...[
                Text(
                  'All calculations has finished, you can send your results to server',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  '100%',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ],
              if (isSendingResultsLoading) ...[
                _progressIndicator(),
              ],
              if (isErrorSendingResult) ...[
                Text(
                  errorMessage,
                  style: textStyle,
                ),
              ],
              const Expanded(child: SizedBox()),
              if (isLoadedCoordinates ||
                  isSendingResultsLoading ||
                  isErrorSendingResult) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DefaultButton(
                    title: 'Send results to server',
                    isDisable: isDisableBtn,
                    onPressed: () {
                      _stopTimer();
                      cubit
                          .sendCoordinateResults(coordinates: coordinatesList)
                          .then(
                        (value) {
                          if (value) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                  coordinates: coordinatesList,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _progressIndicator() {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
