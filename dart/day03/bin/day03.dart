import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day03/input.txt');
  final List<String> lines = await file.readAsLines();

  // partOne(lines);
  partTwo(lines);
}

void partOne(List<String> lines) {
  int total = 0;
  Set<int> usedItems = {};
  for (final String line in lines) {
    usedItems.clear();
    final int midPoint = line.length ~/ 2;
    for (int i = 0; i < midPoint; ++i) {
      int char = line.codeUnitAt(i);
      usedItems.add(char);
    }
    for (int i = midPoint; i < line.length; ++i) {
      final int char = line.codeUnitAt(i);
      if (usedItems.contains(char)) {
        total += calculatePriority(char);
        break;
      }
    }
  }

  print(total);
}

void partTwo(List<String> lines) {
  const int groupSize = 3;

  final int zOffset = 'z'.codeUnitAt(0);
  final List<int> usageCounts = List<int>.filled(zOffset + 1, 0);
  final List<int> usedChars = List<int>.filled(usageCounts.length, 0);

  int total = 0;
  for (int i = 0; i < lines.length; i += groupSize) {
    usageCounts.fillRange(0, usageCounts.length, 0);
    for (int x = 0; x < groupSize; ++x) {
      usedChars.fillRange(0, usedChars.length, 0);
      for (final int char in lines[i + x].codeUnits) {
        if (usedChars[char] == 0) {
          usageCounts[char] += 1;
          usedChars[char] = 1;
        }
      }
    }
    final int badgeChar = usageCounts.indexOf(groupSize);
    total += calculatePriority(badgeChar);
  }

  print(total);
}

final int lowerCaseOffset = 'a'.codeUnitAt(0);
final int upperCaseOffset = 'A'.codeUnitAt(0);

int calculatePriority(int char) {
  if (char >= lowerCaseOffset) {
    return char - lowerCaseOffset + 1;
  }
  return char - upperCaseOffset + 27;
}
