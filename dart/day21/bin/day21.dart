import 'dart:io';
import 'package:day21/day21.dart';

void main(List<String> arguments) async {
  final file = File('../../data/day21/input.txt');
  List<String> lines = await file.readAsLines();

  Map<String, Object> monkeyMap = {};
  for (String line in lines) {
    List<String> splits = line.split(':');
    int? value = int.tryParse(splits[1].trim());
    if (value != null) {
      monkeyMap[splits[0]] = value;
    } else {
      monkeyMap[splits[0]] = Equation.fromString(splits[1].trim());
    }
  }

  int rootValue = getValue('root', monkeyMap);
  print('Part One: $rootValue');

  Equation root = monkeyMap['root']! as Equation;
  int targetValue = getValue(root.secondOperandKey, monkeyMap);
  int humnValue =
      solveFor(targetValue, 'humn', root.firstOperandKey, monkeyMap);
  print('Part Two: $humnValue');
}

int getValue(String key, Map<String, Object> map) {
  Object value = map[key]!;
  if (value is int) {
    return value;
  } else if (value is Equation) {
    int operandA = getValue(value.firstOperandKey, map);
    int operandB = getValue(value.secondOperandKey, map);

    return value.evaluate(operandA, operandB);
  }

  throw StateError('Invalid type in map.');
}

int solveFor(
  int target,
  String targetKey,
  String equationKey,
  Map<String, Object> map,
) {
  String knownKey, unknownKey;
  int knownValue, unknownValue;
  Equation equation = map[equationKey]! as Equation;
  if (dependsOn(equation.firstOperandKey, targetKey, map)) {
    knownKey = equation.secondOperandKey;
    knownValue = getValue(knownKey, map);
    unknownKey = equation.firstOperandKey;
    unknownValue = equation.solveForFirstOperand(knownValue, target);
  } else {
    knownKey = equation.firstOperandKey;
    knownValue = getValue(knownKey, map);
    unknownKey = equation.secondOperandKey;
    unknownValue = equation.solveForSecondOperand(knownValue, target);
  }

  if (unknownKey == targetKey) {
    return unknownValue;
  }

  return solveFor(unknownValue, targetKey, unknownKey, map);
}

bool dependsOn(String key, String dependency, Map<String, Object> map) {
  if (key == dependency) {
    return true;
  }

  Object value = map[key]!;
  if (value is Equation) {
    return dependsOn(value.firstOperandKey, dependency, map) ||
        dependsOn(value.secondOperandKey, dependency, map);
  }

  return false;
}
