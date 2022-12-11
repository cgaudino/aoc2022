import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day10/input.txt');
  List<String> lines = await file.readAsLines();

  CommSystem comms = CommSystem(lines);

  List<StringBuffer> screen = List.generate(6, (index) => StringBuffer());
  const int screenWidth = 40;

  int sum = 0;
  do {
    // Part 1 - sum signal strength
    if ((comms.cycleCount - 19) % 40 == 0) {
      sum += comms.xRegister * (comms.cycleCount + 1);
    }

    // Part 2 - draw sprite
    int row = comms.cycleCount ~/ screenWidth;
    int column = comms.cycleCount % screenWidth;

    if ((column - comms.xRegister).abs() < 2) {
      screen[row].write('#');
    } else {
      screen[row].write('.');
    }
  } while (comms.tick());

  print(sum);

  for (StringBuffer line in screen) {
    print(line.toString());
  }
}

class Instruction {
  int cyclesRemaining = 0;
  Function? onComplete;
}

class CommSystem {
  int xRegister = 1;
  int cycleCount = 0;
  int sourceHead = 0;
  Instruction currentInstruction = Instruction();

  late final List<String> source;

  CommSystem(this.source);

  bool tick() {
    if (cycleCount == 0 || currentInstruction.cyclesRemaining == 0) {
      _loadInstruction();
    }

    cycleCount++;

    currentInstruction.cyclesRemaining -= 1;

    if (currentInstruction.cyclesRemaining == 0) {
      currentInstruction.onComplete?.call();
    }

    return currentInstruction.cyclesRemaining > 0 || sourceHead < source.length;
  }

  void _loadInstruction() {
    List<String> splits = source[sourceHead++].split(' ');

    switch (splits[0]) {
      case 'noop':
        currentInstruction.cyclesRemaining = 1;
        currentInstruction.onComplete = null;
        break;
      case 'addx':
        int operand = int.parse(splits[1]);
        currentInstruction.cyclesRemaining = 2;
        currentInstruction.onComplete = () {
          xRegister += operand;
        };
        break;
    }
  }
}
