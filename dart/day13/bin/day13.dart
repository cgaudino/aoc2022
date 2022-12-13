import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day13/input.txt');
  List<String> lines = await file.readAsLines();

  // Part 1
  int sum = 0;
  for (int i = 0; i < lines.length; i += 3) {
    List<Object> left = parsePacket(lines[i]);
    List<Object> right = parsePacket(lines[i + 1]);

    if (comparePacket(left, right) ?? false) {
      sum += (i ~/ 3) + 1;
    }
  }
  print('Part Two: $sum');

  // Part 2
  List<List<Object>> packets = [];
  for (int i = 0; i < lines.length; i += 3) {
    insertOrdered(packets, parsePacket(lines[i]));
    insertOrdered(packets, parsePacket(lines[i + 1]));
  }
  List<Object> dividerA = parsePacket('[[2]]');
  List<Object> dividerB = parsePacket('[[6]]');
  insertOrdered(packets, dividerA);
  insertOrdered(packets, dividerB);

  int aIndex = packets.indexOf(dividerA) + 1;
  int bIndex = packets.indexOf(dividerB) + 1;
  int key = aIndex * bIndex;
  print('Part One: $key');
}

List<Object> parsePacket(String packetText) {
  int index = 0;

  List<Object> _parsePacketRecursive() {
    List<Object> result = [];
    while (++index < packetText.length) {
      switch (packetText[index]) {
        case '[':
          result.add(_parsePacketRecursive());
          break;
        case ']':
          return result;
        case ',':
          continue;
        default:
          int numberBarrier = packetText.indexOf(RegExp(r'[\[\],]'), index);
          result.add(int.parse(packetText.substring(index, numberBarrier)));
          break;
      }
    }
    return result;
  }

  return _parsePacketRecursive();
}

bool? comparePacket(List<Object> left, List<Object> right) {
  if (right.isEmpty && left.isNotEmpty) {
    return false;
  }

  for (int i = 0; i < right.length; ++i) {
    if (i >= left.length) {
      return true;
    }

    if (left[i] is int && right[i] is int) {
      int l = left[i] as int;
      int r = right[i] as int;
      if (l == r) {
        continue;
      }

      return l < r;
    }

    if (left[i] is int) {
      left[i] = [left[i]];
    }

    if (right[i] is int) {
      right[i] = [right[i]];
    }

    bool? innerPacket =
        comparePacket(left[i] as List<Object>, right[i] as List<Object>);
    if (innerPacket != null) {
      return innerPacket;
    }
  }
  return null;
}

void insertOrdered(List<Object> list, List<Object> item) {
  for (int i = 0; i < list.length; ++i) {
    if (comparePacket(item, list[i] as List<Object>) ?? false) {
      list.insert(i, item);
      return;
    }
  }
  list.add(item);
}
