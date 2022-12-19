import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day16/input.txt');
  List<String> lines = await file.readAsLines();

  final RegExp exp = RegExp(
      r'(Valve )([A-Z]*)( has flow rate=)([0-9]*)(; tunnel(s?) lead(s?) to valve(s?) )(.*)');
  Map<String, Valve> valveMap = {};
  int index = 0;
  int allOpenMask = 0;
  int openMask = 0;
  for (String line in lines) {
    final match = exp.firstMatch(line);
    if (match == null) {
      print('Error parsing input line: ($line)');
      return;
    }

    String valveName = match.group(2)!;
    Valve newValve = Valve(
      int.parse(match.group(4)!),
      1 << index++,
    );
    newValve.neighborNames.addAll(
      match.group(9)!.split(',').map((e) => e.trim()),
    );
    newValve.neighborDistances = List.filled(
      newValve.neighborNames.length,
      1,
      growable: true,
    );

    allOpenMask |= newValve.mask;
    if (newValve.flowRate == 0) {
      openMask |= newValve.mask;
    }

    valveMap[valveName] = newValve;
  }

  for (var valveName in valveMap.keys) {
    Valve valve = valveMap[valveName]!;
    for (int i = valve.neighborNames.length - 1; i >= 0; --i) {
      Valve other = valveMap[valve.neighborNames[i]]!;
      if (other.flowRate == 0) {
        valve.neighborNames.removeAt(i);
        valve.neighborDistances.removeAt(i);
        for (int x = 0; x < other.neighborNames.length; ++x) {
          if (other.neighborNames[x] != valveName) {
            valve.neighborNames.add(other.neighborNames[x]);
            valve.neighborDistances.add(other.neighborDistances[x] + 1);
          }
        }
      }
    }
  }

  const int timeLimit = 30;
  const String firstValve = 'AA';

  Result part1Answer = findMaxPressureRelief(
    firstValve,
    timeLimit,
    valveMap,
    openMask,
    allOpenMask,
    "none",
  );

  print('Part One: ${part1Answer.relief}');

  const int elephantTeachTime = 4;
  Result firstPass = findMaxPressureRelief(
    firstValve,
    timeLimit - elephantTeachTime,
    valveMap,
    openMask,
    allOpenMask,
    "none",
  );
  print(firstPass.openedValves);
  Result secondPass = findMaxPressureRelief(
    firstValve,
    timeLimit - elephantTeachTime,
    valveMap,
    firstPass.openedValves,
    allOpenMask,
    "none",
  );
  print('Part Two: ${firstPass.relief + secondPass.relief}');
}

Result findMaxPressureRelief(
  String currentValveName,
  int timeRemaining,
  Map<String, Valve> map,
  int openedValvesMask,
  int allOpenMask,
  String previousValveName,
) {
  if (timeRemaining < 1) {
    return Result(0, openedValvesMask);
  }

  int relief = 0;
  Valve currentValve = map[currentValveName]!;
  if (currentValve.flowRate == 0) {
    openedValvesMask |= currentValve.mask;
  } else if (openedValvesMask & currentValve.mask == 0) {
    timeRemaining -= 1;
    relief = currentValve.flowRate * timeRemaining;
    openedValvesMask |= currentValve.mask;
  }

  if (openedValvesMask == allOpenMask) {
    return Result(relief, openedValvesMask);
  }

  Result maxNextMove = Result(0, openedValvesMask);
  for (int i = 0; i < currentValve.neighborNames.length; ++i) {
    if (currentValve.neighborNames[i] == previousValveName) {
      continue;
    }
    Result neighborRelief = findMaxPressureRelief(
      currentValve.neighborNames[i],
      timeRemaining - currentValve.neighborDistances[i],
      map,
      openedValvesMask,
      allOpenMask,
      currentValveName,
    );
    if (neighborRelief.relief > maxNextMove.relief) {
      maxNextMove = neighborRelief;
    }
  }

  return Result(relief + maxNextMove.relief, maxNextMove.openedValves);
}

class Valve {
  late final int flowRate;
  late final int mask;

  List<String> neighborNames = [];
  List<int> neighborDistances = [];

  Valve(this.flowRate, this.mask);
}

class Result {
  late final int relief;
  late final int openedValves;

  Result(this.relief, this.openedValves);
}
