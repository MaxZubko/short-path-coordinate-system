import 'package:flutter/material.dart';
import 'package:short_path_coordinate_system/features/preview_screen/preview_screen.dart';

import '../../models/coordinates_model.dart';

class ResultScreenBody extends StatefulWidget {
  final List<CoordinateModel> coordinates;
  const ResultScreenBody({
    super.key,
    required this.coordinates,
  });

  @override
  State<ResultScreenBody> createState() => _ResultScreenBodyState();
}

class _ResultScreenBodyState extends State<ResultScreenBody> {
  late List<CoordinateModel> _coordinates;

  @override
  void initState() {
    super.initState();
    _coordinates = widget.coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _coordinates.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        final coordinate = _coordinates[index];

        return _item(coordinate);
      },
    );
  }

  Widget _item(CoordinateModel coordinate) {
    final path = coordinate.path;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PreviewScreen(
              field: coordinate.field,
              start: coordinate.start,
              end: coordinate.end,
              path: path ?? '',
            ),
          ),
        );
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(path ?? ''),
      ),
    );
  }
}
