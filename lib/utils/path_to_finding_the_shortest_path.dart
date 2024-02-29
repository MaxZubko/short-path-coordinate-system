import 'dart:collection';

class CoordinatesHelper {
  List<Map<String, int>> findShortestPath(
      List<String> field, Map<String, int> start, Map<String, int> end) {
    List<Map<String, int>> shortestPath = [];

    int rows = field.length;
    int cols = field[0].length;

    bool isValid(int x, int y) {
      return x >= 0 && x < cols && y >= 0 && y < rows && field[y][x] != 'X';
    }

    Queue<Map<String, int>> queue = Queue();
    Map<String, int> initial = {'x': start['x']!, 'y': start['y']!};
    queue.add(initial);

    Map<String, Map<String, int>> parent = {};
    parent[initial.toString()] = initial;

    bool reachedEnd = false;

    while (queue.isNotEmpty && !reachedEnd) {
      Map<String, int> current = queue.removeFirst();
      int x = current['x']!;
      int y = current['y']!;

      List<Map<String, int>> neighbors = [
        {'x': x + 1, 'y': y},
        {'x': x - 1, 'y': y},
        {'x': x, 'y': y + 1},
        {'x': x, 'y': y - 1},
        {'x': x + 1, 'y': y + 1},
        {'x': x - 1, 'y': y - 1},
        {'x': x + 1, 'y': y - 1},
        {'x': x - 1, 'y': y + 1},
      ];

      for (Map<String, int> neighbor in neighbors) {
        int nx = neighbor['x']!;
        int ny = neighbor['y']!;
        if (isValid(nx, ny) && !parent.containsKey(neighbor.toString())) {
          parent[neighbor.toString()] = current;
          queue.add(neighbor);
          if (nx == end['x'] && ny == end['y']) {
            reachedEnd = true;
            break;
          }
        }
      }
    }

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
