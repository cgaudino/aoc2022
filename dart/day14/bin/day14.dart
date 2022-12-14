import 'dart:io';

import 'package:day12/pathfinding.dart';
import 'package:day14/world.dart';

void main(List<String> arguments) async {
  final file = File('../../data/day14/input.txt');
  List<String> lines = await file.readAsLines();

  const Vector2 sandSpawnPoint = Vector2(500, 0);

  World world = World(lines, true);
  int sandCount = 0;
  while (!world.sandFallsToInfinity(sandSpawnPoint)) {
    sandCount += 1;
  }
  // print(world.toString());
  print('Part One: $sandCount');

  world = World(lines, false);
  sandCount = 0;
  do {
    sandCount += 1;
  } while (world.getSandRestPosition(sandSpawnPoint) != sandSpawnPoint);
  // print(world.toString());
  print('Part Two: $sandCount');
}
