import 'package:flutter/material.dart';

import '../../constants/colors.dart' as constants;
import '../../utils/path_to_finding_the_shortest_path.dart';

class PreviewScreenBody extends StatefulWidget {
  final List<String> field;
  final Map<String, int> start;
  final Map<String, int> end;
  final String path;

  const PreviewScreenBody({
    super.key,
    required this.field,
    required this.start,
    required this.end,
    required this.path,
  });

  @override
  State<PreviewScreenBody> createState() => _PreviewScreenBodyState();
}

class _PreviewScreenBodyState extends State<PreviewScreenBody> {
  final CoordinatesHelper _helper = CoordinatesHelper();

  late List<String> field;
  late Map<String, int> start;
  late Map<String, int> end;
  late String path;

  Color blockedCellColor = constants.Colors.blockedCellColor;
  Color startCellColor = constants.Colors.startCellColor;
  Color endCellColor = constants.Colors.endCellColor;
  Color shortestCellColor = constants.Colors.shortestCellColor;

  late Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();

    field = widget.field;
    start = widget.start;
    end = widget.end;
    path = widget.path;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Color>> cellColors = getColorMatrix(field, start, end);
    List<Map<String, int>> shortestPath =
        _helper.findShortestPath(field, start, end);

    return Center(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: field[0].length,
            ),
            itemCount: field.length * field[0].length,
            itemBuilder: (BuildContext context, int index) {
              int rowIndex = index ~/ field[0].length;
              int columnIndex = index % field[0].length;
              String value = (columnIndex + rowIndex * 0.1).toStringAsFixed(1);

              if (field[rowIndex][columnIndex] == 'X') {
                textColor = Colors.white;
              } else {
                textColor = Colors.black;
              }

              return Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: cellColors[rowIndex][columnIndex],
                ),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(path),
        ],
      ),
    );
  }

  List<List<Color>> getColorMatrix(
      List<String> field, Map<String, int> start, Map<String, int> end) {
    List<List<Color>> cellColors = List.generate(
      field.length,
      (i) => List.filled(field[i].length, Colors.white),
    );

    // color to the starting position (green)
    int startX = start['x']!;
    int startY = start['y']!;
    cellColors[startY][startX] = startCellColor;

    // color to end position (red)
    int endX = end['x']!;
    int endY = end['y']!;
    cellColors[endY][endX] = endCellColor;

    // get the shortest path
    List<Map<String, int>> shortestPath =
        _helper.findShortestPath(field, start, end);

    // color to cells included in the shortest path (orange)
    for (Map<String, int> point in shortestPath) {
      int x = point['x']!;
      int y = point['y']!;
      // check that the coordinates do not coincide with either start or end
      if (!(x == start['x'] && y == start['y']) &&
          !(x == end['x'] && y == end['y'])) {
        cellColors[y][x] = shortestCellColor;
      }
    }

    // color to black cells
    for (int i = 0; i < field.length; i++) {
      for (int j = 0; j < field[i].length; j++) {
        if (field[i][j] == 'X') {
          cellColors[i][j] = blockedCellColor;
        }
      }
    }
    return cellColors;
  }
}
