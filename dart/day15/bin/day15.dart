import 'dart:io';

import 'package:day12/pathfinding.dart';

void main(List<String> arguments) async {
  final file = File('../../data/day15/input.txt');
  List<String> lines = await file.readAsLines();

  Vector2 min = Vector2(9999999999, 99999999999),
      max = Vector2(-9999999999, -99999999);
  List<Vector2> sensors = [];
  Set<Vector2> beacons = {};
  List<int> radii = [];

  // Parse input
  final RegExp xRegExp = RegExp(r'x=-?[0-9]*');
  final RegExp yRegExp = RegExp(r'y=-?[0-9]*');
  for (String line in lines) {
    final xMatches = xRegExp.allMatches(line).toList();
    final yMatches = yRegExp.allMatches(line).toList();

    assert(xMatches.length == 2);
    assert(yMatches.length == 2);

    final Vector2 sensorPosition = Vector2(
        int.parse(line.substring(xMatches[0].start + 2, xMatches[0].end)),
        int.parse(line.substring(yMatches[0].start + 2, yMatches[0].end)));

    final Vector2 beaconPosition = Vector2(
        int.parse(line.substring(xMatches[1].start + 2, xMatches[1].end)),
        int.parse(line.substring(yMatches[1].start + 2, yMatches[1].end)));

    Vector2 delta = sensorPosition - beaconPosition;
    int distance = delta.x.abs() + delta.y.abs();

    sensors.add(sensorPosition);
    beacons.add(beaconPosition);
    radii.add(distance);

    Vector2 offset = Vector2(distance, distance);
    min = expandMin(min, sensorPosition - offset);
    max = expandMax(max, sensorPosition + offset);
  }

  // Part One
  const int inspectRow = 2000000;
  int invalidCount = 0;
  for (int x = min.x; x <= max.x; ++x) {
    Vector2 position = Vector2(x, inspectRow);
    if (!beacons.contains(position) &&
        !positionIsEmpty(Vector2(x, inspectRow), sensors, radii, beacons)) {
      invalidCount += 1;
    }
  }
  print('Part One: $invalidCount');

  // Part Two
  Vector2? signalPosition;
  const int scanAreaSize = 4000000;
  // Scan around perimiter of each signal's radius
  for (int i = 0; i < sensors.length; ++i) {
    for (int x = -radii[i] - 1; x <= radii[i] + 1; ++x) {
      Vector2 testTop = Vector2(x, radii[i] + 1 - x.abs()) + sensors[i];
      Vector2 testBot = Vector2(x, -testTop.y) + sensors[i];

      if (testTop.x < 0 || testTop.x > scanAreaSize) {
        continue;
      }

      if (testTop.y >= 0 &&
          testTop.y <= scanAreaSize &&
          positionIsEmpty(testTop, sensors, radii, beacons)) {
        signalPosition = testTop;
        break;
      }
      if (testBot.y >= 0 &&
          testBot.y <= scanAreaSize &&
          positionIsEmpty(testBot, sensors, radii, beacons)) {
        signalPosition = testBot;
        break;
      }
    }
    if (signalPosition != null) {
      break;
    }
  }

  if (signalPosition != null) {
    int frequency = signalPosition.x * scanAreaSize + signalPosition.y;
    print('Part Two: $frequency');
  } else {
    print('Part Two: fail');
  }
}

bool positionIsEmpty(Vector2 position, List<Vector2> sensors, List<int> radii,
    Set<Vector2> beacons) {
  if (beacons.contains(position)) {
    return false;
  }

  for (int i = 0; i < sensors.length; ++i) {
    Vector2 delta = sensors[i] - position;
    int distance = delta.x.abs() + delta.y.abs();
    if (distance <= radii[i]) {
      return false;
    }
  }
  return true;
}

Vector2 expandMin(Vector2? min, Vector2 x) {
  if (min == null) {
    return x;
  }

  if (x.x < min.x) {
    min = Vector2(x.x, min.y);
  }
  if (x.y < min.y) {
    min = Vector2(min.x, x.y);
  }
  return min;
}

Vector2 expandMax(Vector2? max, Vector2 x) {
  if (max == null) {
    return x;
  }

  if (x.x > max.x) {
    max = Vector2(x.x, max.y);
  }
  if (x.y > max.y) {
    max = Vector2(max.x, x.y);
  }
  return max;
}
