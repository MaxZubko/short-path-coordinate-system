import 'dart:collection';

class CoordinatesHelper {
  /// method [findShortestPath] used to find the shortest path between two points on a grid
  List<Map<String, int>> findShortestPath(
      List<String> field, Map<String, int> start, Map<String, int> end) {
    List<Map<String, int>> shortestPath = [];

    /// rows - number of rows in the grid
    int rows = field.length;

    /// cols - number of columns in grid
    int cols = field[0].length;

    /// the method checks whether a given coordinate is valid on the grid
    bool isValid(int x, int y) {
      return x >= 0 && x < cols && y >= 0 && y < rows && field[y][x] != 'X';
    }

    Queue<Map<String, int>> queue = Queue();
    Map<String, int> initial = {'x': start['x']!, 'y': start['y']!};
    queue.add(initial);

    Map<String, Map<String, int>> parent = {};
    parent[initial.toString()] = initial;

    bool reachedEnd = false;

    /// a loop is used to traverse all the cells in a field in order to find
    /// the shortest path from the starting point to the ending point
    while (queue.isNotEmpty && !reachedEnd) {
      Map<String, int> current = queue.removeFirst();
      int x = current['x']!;
      int y = current['y']!;

      /// list of neighboring coordinates relative to the current coordinate
      List<Map<String, int>> neighbors = [
        /// Coordinate to the right of the current one.
        {'x': x + 1, 'y': y},

        /// Coordinate to the left of the current one.
        {'x': x - 1, 'y': y},

        /// The coordinate is below the current one.
        {'x': x, 'y': y + 1},

        /// The coordinate is higher than the current one.
        {'x': x, 'y': y - 1},

        /// Coordinate to the bottom right of the current one (diagonal)
        {'x': x + 1, 'y': y + 1},

        /// The coordinate is at the top left of the current one (diagonally).
        {'x': x - 1, 'y': y - 1},

        /// Coordinate to the top right of the current one (diagonal)
        {'x': x + 1, 'y': y - 1},

        /// The coordinate is below to the left of the current one (diagonally).
        {'x': x - 1, 'y': y + 1},
      ];

      /// the loop is responsible for traversing all neighboring coordinates of
      /// the current coordinate and adding them to the queue for further exploration
      for (Map<String, int> neighbor in neighbors) {
        int nx = neighbor['x']!;
        int ny = neighbor['y']!;
        if (isValid(nx, ny) && !parent.containsKey(neighbor.toString())) {
          parent[neighbor.toString()] = current;
          queue.add(neighbor);

          /// verifying that the endpoint has been reached
          if (nx == end['x'] && ny == end['y']) {
            reachedEnd = true;
            break;
          }
        }
      }
    }

    /// here a shortestPath list is formed, which contains the coordinates of
    /// the cells that form the shortest path from the starting point to the ending point.
    if (reachedEnd) {
      Map<String, int> current = end;
      while (current.toString() != start.toString()) {
        shortestPath.add(current);
        current = parent[current.toString()]!;
      }
      shortestPath.add(start);
      shortestPath = shortestPath.reversed.toList();
    }

    return shortestPath;
  }

  String formatCoordinate(Map<String, int> coordinate) {
    return '(${coordinate['x']},${coordinate['y']})';
  }

  String formatCoordinatesList(List<Map<String, int>> coordinatesList) {
    String result = '';
    for (int i = 0; i < coordinatesList.length; i++) {
      result += formatCoordinate(coordinatesList[i]);
      if (i < coordinatesList.length - 1) {
        result += '->';
      }
    }
    return result;
  }

  List<Map<String, String>> formatSteps(String path) {
    List<Map<String, String>> steps = [];

    List<String> stepsList = path.split("->");
    stepsList.forEach((step) {
      // removing the parentheses
      step = step.replaceAll("(", "").replaceAll(")", "");
      // split the element into x and y coordinates using the separator ","
      List<String> coordinates = step.split(",");
      steps.add({
        'x': coordinates[0].trim(),
        'y': coordinates[1].trim(),
      });
    });

    return steps;
  }
}
