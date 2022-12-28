import 'dart:io';

final int invalid = ' '.codeUnitAt(0);
final int empty = '.'.codeUnitAt(0);
final int wall = '#'.codeUnitAt(0);
final int left = 'L'.codeUnitAt(0);
final int right = 'R'.codeUnitAt(0);

void main(List<String> arguments) async {
  final file = File('../../data/day22/input.txt');
  List<String> lines = await file.readAsLines();

  List<List<int>> map = [];
  int width = lines[0].codeUnits.length;
  for (String line in lines) {
    if (line.isEmpty) {
      break;
    }
    List<int> row = List.filled(width, invalid);
    row.setAll(0, line.codeUnits);
    map.add(row);
  }

  // (y, x);
  List<int> direction = [0, 1];
  List<int> position = [0, map[0].indexWhere((element) => element == empty)];

  String instructions = lines.last;
  List<int> neighbor = [0, 0];
  RegExp regex = RegExp(r'([0-9]*)');
  for (int i = 0; i < instructions.length; ++i) {
    if (instructions.codeUnitAt(i) == left) {
      rotate(-1, direction);
      continue;
    }
    if (instructions.codeUnitAt(i) == right) {
      rotate(1, direction);
      continue;
    }

    Match? match = regex.matchAsPrefix(instructions, i);
    if (match == null) {
      throw StateError("Failed to parse instructions.");
    }

    int steps = int.parse(instructions.substring(match.start, match.end));
    i += match.end - match.start - 1;

    for (int s = 0; s < steps; ++s) {
      findNeighbor(position, direction, neighbor, map);
      if (map[neighbor[0]][neighbor[1]] == wall) {
        break;
      }
      position[0] = neighbor[0];
      position[1] = neighbor[1];
    }
  }

  int row = position[0] + 1;
  int column = position[1] + 1;
  int score = row * 1000 + column * 4 + directionScore(direction);
  print('Part One: $score');
}

void rotate(int rotation, List<int> direction) {
  int index = direction.indexWhere((element) => element != 0) + rotation;
  int sign = -1;
  if (index < 0 || index > 1) {
    sign = 1;
  }
  int temp = direction[0] * sign;
  direction[0] = direction[1] * sign;
  direction[1] = temp;
}

void findNeighbor(
  List<int> position,
  List<int> direction,
  List<int> neighbor,
  List<List<int>> map,
) {
  neighbor.setAll(0, position);
  add(neighbor, direction, map);
  if (map[neighbor[0]][neighbor[1]] != invalid) {
    return;
  }
  neighbor.setAll(0, position);
  do {
    subtract(neighbor, direction, map);
  } while (map[neighbor[0]][neighbor[1]] != invalid);
  add(neighbor, direction, map);
}

void add(List<int> a, List<int> b, List<List<int>> map) {
  a[0] += b[0];
  if (a[0] < 0) {
    a[0] = map.length - 1;
  } else if (a[0] >= map.length) {
    a[0] = 0;
  }

  a[1] += b[1];
  if (a[1] < 0) {
    a[1] = map[a[0]].length - 1;
  } else if (a[1] >= map[a[0]].length) {
    a[1] = 0;
  }
}

void subtract(List<int> a, List<int> b, List<List<int>> map) {
  a[0] -= b[0];
  if (a[0] < 0) {
    a[0] = map.length - 1;
  } else if (a[0] >= map.length) {
    a[0] = 0;
  }

  a[1] -= b[1];
  if (a[1] < 0) {
    a[1] = map[a[0]].length - 1;
  } else if (a[1] >= map[a[0]].length) {
    a[1] = 0;
  }
}

int directionScore(List<int> direction) {
  if (direction[0] == 0) {
    return direction[1] > 1 ? 0 : 2;
  }
  return direction[0] > 0 ? 1 : 3;
}
