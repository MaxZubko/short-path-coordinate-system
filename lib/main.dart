import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:short_path_coordinate_system/cubit/coordinates_cubit/coordinates_cubit.dart';
import 'package:short_path_coordinate_system/repositories/coordinates_repository/coordinates_repository.dart';

import 'app.dart';

void main() {
  runApp(BlocProvider<CoordinatesCubit>(
      create: (context) => CoordinatesCubit(
            CoordinatesRepository(),
          ),
      child: const MyApp()));
}
