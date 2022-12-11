import 'dart:io';
import 'dart:collection';

void main(List<String> arguments) async {
  final file = File('../../data/day05/input.txt');
  final List<String> lines = await file.readAsLines();

  final int diagramBottomIndex = findBottomOfDiagram(lines);
  List<ListQueue<int>> stacks = parseStackDiagram(lines, diagramBottomIndex);
  interpretInstructions(lines, stacks, diagramBottomIndex);
  printTopOfStacks(stacks);
}

int findBottomOfDiagram(List<String> lines) {
  return lines.indexWhere(
    (element) => element.startsWith(' 1 '),
  );
}

final int spaceChar = ' '.codeUnitAt(0);

List<ListQueue<int>> parseStackDiagram(
    List<String> lines, final int diagramBottomIndex) {
  assert(diagramBottomIndex > 0);

  final int stackCount = lines[diagramBottomIndex]
      .split(' ')
      .where((element) => element.isNotEmpty)
      .length;

  assert(stackCount > 0);

  List<ListQueue<int>> stacks = [];

  for (int i = 0; i < stackCount; ++i) {
    int column = 1 + (i * 4);
    ListQueue<int> stack = ListQueue<int>();
    for (int s = diagramBottomIndex - 1; s >= 0; --s) {
      int char = lines[s].codeUnitAt(column);
      if (char == spaceChar) break;
      stack.add(char);
    }
    stacks.add(stack);
  }

  return stacks;
}

void interpretInstructions(List<String> lines, List<ListQueue<int>> stacks,
    final int diagramBottomIndex) {
  for (int i = diagramBottomIndex + 2; i < lines.length; ++i) {
    List<String> splits = lines[i].split(' ');
    assert(splits.length == 6);

    int numToMove = int.parse(splits[1]);
    int moveSource = int.parse(splits[3]) - 1;
    int moveTarget = int.parse(splits[5]) - 1;

    // movePartOne(stacks, numToMove, moveSource, moveTarget);
    movePartTwo(stacks, numToMove, moveSource, moveTarget);
  }
}

void movePartOne(List<ListQueue<int>> stacks, final int numToMove,
    final int moveSource, final int moveTarget) {
  for (int m = 0; m < numToMove; m++) {
    int value = stacks[moveSource].removeLast();
    stacks[moveTarget].addLast(value);
  }
}

final ListQueue<int> moveBuffer = ListQueue<int>();

void movePartTwo(List<ListQueue<int>> stacks, final int numTomove,
    final int moveSource, final int moveTarget) {
  moveBuffer.clear();
  for (int i = 0; i < numTomove; ++i) {
    moveBuffer.addFirst(stacks[moveSource].removeLast());
  }
  stacks[moveTarget].addAll(moveBuffer);
}

void printTopOfStacks(List<ListQueue<int>> stacks) {
  print(
      String.fromCharCodes(stacks.map((e) => e.isEmpty ? spaceChar : e.last)));
}
