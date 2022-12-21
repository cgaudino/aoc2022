import 'dart:io';
import 'package:day18/day18.dart';

const List<Vector3Int> offsets = [
  Vector3Int(0, -1, 0), // Bottom
  Vector3Int(0, 1, 0), // Top
  Vector3Int(-1, 0, 0), // Left
  Vector3Int(1, 0, 0), // Right
  Vector3Int(0, 0, 1), // Front
  Vector3Int(0, 0, -1), // Back
];

void main(List<String> arguments) async {
  final file = File('../../data/day18/input.txt');
  List<String> lines = await file.readAsLines();

  BoundingBox extents = BoundingBox();
  List<Vector3Int> coordsList = [];
  Set<Vector3Int> coordsSet = {};
  for (String line in lines) {
    Vector3Int coord = Vector3Int.tryParse(line)!;
    coordsSet.add(coord);
    coordsList.add(coord);
    extents.envelop(coord);
  }

  Set<Vector3Int> visitedCoords = {};
  int numSides = 0;
  int numExposedSides = 0;
  for (Vector3Int coord in coordsList) {
    for (Vector3Int offset in offsets) {
      Vector3Int neighbor = coord + offset;
      if (!coordsSet.contains(neighbor)) {
        numSides += 1;

        visitedCoords.clear();

        if (floodFillEscapesExtents(
            neighbor, extents, coordsSet, visitedCoords)) {
          numExposedSides += 1;
        }
      }
    }
  }
  print('Part One: $numSides');
  print('Part Two: $numExposedSides');
}

bool floodFillEscapesExtents(
  Vector3Int coord,
  BoundingBox extents,
  Set<Vector3Int> cubes,
  Set<Vector3Int> visitedCoords,
) {
  visitedCoords.add(coord);

  if (cubes.contains(coord)) {
    return false;
  }

  if (!extents.contains(coord)) {
    return true;
  }

  for (Vector3Int offset in offsets) {
    Vector3Int neighbor = coord + offset;
    if (visitedCoords.contains(neighbor)) {
      continue;
    }

    if (floodFillEscapesExtents(neighbor, extents, cubes, visitedCoords)) {
      return true;
    }
  }

  return false;
}
