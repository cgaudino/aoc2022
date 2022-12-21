import 'dart:io';
import 'dart:math';

import 'package:day17/grid_list.dart';
import 'package:day17/rock.dart';
import 'package:day17/vector_2_int.dart';

const int gridWidth = 7;
const int emptyValue = 0;
const int filledValue = 1;

const Vector2Int down = Vector2Int(0, -1);

final List<Rock> rocks = [
  // -
  Rock([
    Vector2Int(0, 0),
    Vector2Int(1, 0),
    Vector2Int(2, 0),
    Vector2Int(3, 0),
  ]),
  // +
  Rock([
    Vector2Int(1, 0),
    Vector2Int(0, 1),
    Vector2Int(2, 1),
    Vector2Int(1, 2),
  ]),
  // L (backwards)
  Rock([
    Vector2Int(0, 0),
    Vector2Int(1, 0),
    Vector2Int(2, 0),
    Vector2Int(2, 1),
    Vector2Int(2, 2),
  ]),
  // |
  Rock([
    Vector2Int(0, 0),
    Vector2Int(0, 1),
    Vector2Int(0, 2),
    Vector2Int(0, 3),
  ]),
  // o
  Rock([
    Vector2Int(0, 0),
    Vector2Int(1, 0),
    Vector2Int(0, 1),
    Vector2Int(1, 1),
  ])
];

class State {
  int iteration = 0;
  int height = 0;

  State(this.iteration, this.height);
}

void main(List<String> arguments) async {
  final file = File('../../data/day17/input.txt');
  final String input = (await file.readAsString()).trim();

  GridList grid = GridList(gridWidth, emptyValue);

  const int partOneIterations = 2022;
  const int partTwoIterations = 1000000000000;
  int partOneResult = 0;
  int partTwoSkippedHeight = 0;

  Map<int, State> states = {};

  int directionIndex = 0;
  for (int i = 0; i < partTwoIterations; ++i) {
    int state = Object.hash(
      (i % rocks.length),
      (directionIndex % input.length),
    );

    int heightBeforeRock = grid.height;

    Rock rock = rocks[i % rocks.length];
    Vector2Int pos = Vector2Int(2, grid.height + 3);
    while (true) {
      Vector2Int jetDirection = getDirection(input, directionIndex++);

      Vector2Int testPosition = pos + jetDirection;
      if (!rockCollides(rock, testPosition, grid)) {
        pos = testPosition;
      }

      testPosition = pos + down;

      if (rockCollides(rock, testPosition, grid)) {
        for (Vector2Int rockPart in rock) {
          grid[rockPart + pos] = filledValue;
        }
        break;
      }

      pos = testPosition;
    }

    if (i == partOneIterations - 1) {
      partOneResult = grid.height;
      print('Part One: $partOneResult');
    }

    state = Object.hash(state, grid.height - heightBeforeRock);

    if (partTwoSkippedHeight == 0 &&
        states.containsKey(state) &&
        i >= partOneIterations) {
      State prev = states[state]!;
      int interval = i - prev.iteration;
      int growth = grid.height - prev.height;
      int remainingIterations = partTwoIterations - i;
      int numCycles = remainingIterations ~/ interval;
      states.clear();
      partTwoSkippedHeight = growth * numCycles;
      i += numCycles * interval;
    } else {
      states[state] = State(i, grid.height);
    }
  }

  print('Part Two: ${grid.height + partTwoSkippedHeight}');
}

bool rockCollides(Rock rock, Vector2Int rockPosition, GridList grid) {
  return rock.any((part) {
    Vector2Int testPosition = part + rockPosition;
    return testPosition.x < 0 ||
        testPosition.y < 0 ||
        testPosition.x >= grid.width ||
        grid[testPosition] != emptyValue;
  });
}

Vector2Int getDirection(String input, int index) {
  switch (input[index % input.length]) {
    case '<':
      return Vector2Int(-1, 0);
    case '>':
      return Vector2Int(1, 0);

    default:
      throw StateError(
          'Unknown direction character: ${input[index % input.length]}');
  }
}

int calcSurfaceSize(GridList grid) {
  int lowest = 0;
  for (int x = 0; x < grid.width; ++x) {
    for (int y = grid.height - 1; y >= 0; --y) {
      if (grid[Vector2Int(x, y)] != emptyValue) {
        int depression = grid.height - y;
        if (depression > lowest) {
          lowest = depression;
        }
        break;
      }
    }
  }
  return min(lowest * grid.width, grid.data.length);
}
