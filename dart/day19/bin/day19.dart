import 'dart:io';
import 'package:day19/day19.dart';

void main(List<String> arguments) async {
  final file = File('../../data/day19/input.txt');
  List<String> lines = await file.readAsLines();

  const int partOneTimeLimit = 24;
  const int partTwoTimeLimit = 32;

  List<State> partTwoStartingStates = [];

  final RegExp regex = RegExp(
      r'(Blueprint )([0-9]*)(: Each ore robot costs )([0-9]*)( ore. Each clay robot costs )([0-9]*)( ore. Each obsidian robot costs )([0-9]*)( ore and )([0-9]*)( clay. Each geode robot costs )([0-9]*)( ore and )([0-9]*)( obsidian.)');
  const int idIndex = 2;
  const int oreCostIndex = 4;
  const int clayCostIndex = 6;
  const int obsidianOreCostIndex = 8;
  const int obsidianClayCostIndex = 10;
  const int geodeOreCost = 12;
  const int geodeObsidianCost = 14;
  int qualitySum = 0;
  for (String line in lines) {
    final match = regex.firstMatch(line);
    if (match == null) {
      print('Failed to match line: $line');
      continue;
    }

    int id = int.parse(match.group(idIndex)!);

    State state = State();
    state.robots[oreIndex] = 1;

    state.costs[oreIndex][oreIndex] = int.parse(match.group(oreCostIndex)!);
    state.costs[clayIndex][oreIndex] = int.parse(match.group(clayCostIndex)!);
    state.costs[obsidianIndex][oreIndex] =
        int.parse(match.group(obsidianOreCostIndex)!);
    state.costs[obsidianIndex][clayIndex] =
        int.parse(match.group(obsidianClayCostIndex)!);
    state.costs[geodeIndex][oreIndex] = int.parse(match.group(geodeOreCost)!);
    state.costs[geodeIndex][obsidianIndex] =
        int.parse(match.group(geodeObsidianCost)!);

    state.limits.setRange(
        oreIndex,
        geodeIndex,
        Iterable<int>.generate(4, (index) {
          int sum = 0;
          for (List<int> cost in state.costs) {
            sum = sum > cost[index] ? sum : cost[index];
          }
          return sum;
        }));

    if (partTwoStartingStates.length < 3) {
      partTwoStartingStates.add(State.from(state));
    }

    int maxGeodes = maximizeGeodeProduction(state, partOneTimeLimit);
    qualitySum += maxGeodes * id;
  }
  print('Part One: $qualitySum');

  int partTwoProduct = 1;
  for (State state in partTwoStartingStates) {
    partTwoProduct *= maximizeGeodeProduction(state, partTwoTimeLimit);
  }
  print('Part Two: $partTwoProduct');
}

int maximizeGeodeProduction(State state, int timeRemaining,
    {int maxSoFar = 0}) {
  if (timeRemaining <= 0) {
    return state.resources[geodeIndex];
  }

  if (maxSoFar > 0) {
    int t = timeRemaining * (timeRemaining - 1) ~/ 2;
    if (state.resources[geodeIndex] +
            (state.robots[geodeIndex] + t) * timeRemaining <
        maxSoFar) {
      return 0;
    }
  }

  int max = maxSoFar;
  for (int i = oreIndex; i <= geodeIndex; ++i) {
    if (state.robots[i] > state.limits[i] && i < geodeIndex) {
      continue;
    }

    int branchTime = timeRemaining;
    State next = State.from(state);

    while (!canAfford(next.resources, next.costs[i]) && branchTime > 0) {
      harvestResources(next);
      branchTime -= 1;
    }

    if (branchTime > 0) {
      harvestResources(next);
      buildRobot(next, i);
      branchTime -= 1;
    }

    int value = maximizeGeodeProduction(next, branchTime, maxSoFar: max);
    if (value > max) {
      max = value;
    }
  }

  return max;
}

bool canAfford(List<int> resources, List<int> costs) {
  for (int i = 0; i < costs.length; ++i) {
    if (resources[i] < costs[i]) {
      return false;
    }
  }
  return true;
}

void harvestResources(State state) {
  for (int i = oreIndex; i <= geodeIndex; ++i) {
    state.resources[i] += state.robots[i];
  }
}

void buildRobot(State state, int robotType) {
  state.robots[robotType] += 1;
  for (int i = oreIndex; i <= geodeIndex; ++i) {
    state.resources[i] -= state.costs[robotType][i];
  }
}
