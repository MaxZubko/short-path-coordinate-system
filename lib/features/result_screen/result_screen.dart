import 'package:flutter/material.dart';
import 'package:short_path_coordinate_system/features/result_screen/result_screen_body.dart';

import '../../models/coordinates_model.dart';

class ResultScreen extends StatelessWidget {
  final List<CoordinateModel> coordinates;
  const ResultScreen({
    super.key,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
      ),
      body: ResultScreenBody(
        coordinates: coordinates,
      ),
    );
  }
}
