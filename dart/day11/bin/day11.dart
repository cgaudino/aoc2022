import 'dart:collection';
import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day11/input.txt');
  List<String> lines = await file.readAsLines();

  List<Monkey> monkeys = [];
  int commonFactor = 1;
  for (int i = 0; i < lines.length; i += 7) {
    Monkey monkey = Monkey(lines, i);
    commonFactor *= monkey.testDivisor;
    monkeys.add(monkey);
  }

  // const int numRounds = 20;
  const int numRounds = 10000;

  for (int i = 0; i < numRounds; i++) {
    for (Monkey monkey in monkeys) {
      while (monkey.items.isNotEmpty) {
        int item = monkey.inspectItem();
        // item = (item / 3).floor();
        int throwTarget =
            monkey.test(item) ? monkey.targetIfTrue : monkey.targetIfFalse;
        monkeys[throwTarget].items.addLast(item % commonFactor);
      }
    }
  }

  monkeys.sort((a, b) => -a.inspectionCounter.compareTo(b.inspectionCounter));
  print(monkeys[0].inspectionCounter * monkeys[1].inspectionCounter);
}

class Monkey {
  late final ListQueue<int> items;

  late final int Function(int) operandA;
  late final int Function(int) operandB;
  late final int Function(int, int) operator;

  late final bool Function(int) test;
  late final int testDivisor;

  late final int targetIfTrue;
  late final int targetIfFalse;

  int inspectionCounter = 0;

  static const String colon = ':';
  static const String comma = ',';
  static const String equals = '=';
  static const String space = ' ';

  Monkey(List<String> input, int line) {
    // Parse starting items
    String itemsLine = input[line + 1];
    String itemsList = itemsLine.substring(itemsLine.indexOf(colon) + 1);
    List<String> itemsListSplits = itemsList.split(comma);
    items = ListQueue<int>(itemsListSplits.length * 2);
    items.addAll(itemsListSplits.map((e) => int.parse(e)));

    // Parse operation
    String opLine = input[line + 2];
    String opText = opLine.substring(opLine.indexOf(equals) + 2);
    List<String> opSplits = opText.split(space);
    operandA = _getOperandFunction(opSplits[0]);
    operandB = _getOperandFunction(opSplits[2]);
    operator = _getOperatorFunction(opSplits[1]);

    // Parse test
    String testLine = input[line + 3];
    List<String> testLineSplits = testLine.split(space);
    testDivisor = int.parse(testLineSplits.last);
    test = (x) => x % testDivisor == 0;

    // Parse test result actions
    targetIfTrue = int.parse(input[line + 4].split(space).last);
    targetIfFalse = int.parse(input[line + 5].split(space).last);
  }

  int inspectItem() {
    int item = items.removeFirst();
    inspectionCounter += 1;
    return operator(operandA(item), operandB(item));
  }

  int Function(int) _getOperandFunction(String operandText) {
    if (operandText.contains('old')) {
      return (x) => x;
    }
    int number = int.parse(operandText.trim());
    return (x) => number;
  }

  int Function(int, int) _getOperatorFunction(String operatorText) {
    switch (operatorText) {
      case '*':
        return (x, y) => x * y;
      case '+':
        return (x, y) => x + y;

      default:
        throw Exception('$operatorText is not a valid operator');
    }
  }
}
