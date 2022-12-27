import 'dart:io';
import 'package:day20/day20.dart';

void main(List<String> arguments) async {
  final file = File('../../data/day20/input.txt');
  List<Node<int>> originalOrder = [];
  for (String line in await file.readAsLines()) {
    int value = int.parse(line);
    Node<int> node = Node();
    node.value = value;
    originalOrder.add(node);
  }

  print('Part One: ${decrypt(originalOrder)}');
  print('Part Two: ${decrypt(
    originalOrder,
    decryptionKey: 811589153,
    mixIterations: 10,
  )}');
}

int decrypt(
  List<Node<int>> originalOrder, {
  int decryptionKey = 1,
  int mixIterations = 1,
}) {
  List<Node<int>> mixed =
      List.generate(originalOrder.length, (index) => originalOrder[index]);

  for (int i = 0; i < mixIterations; ++i) {
    for (Node<int> node in originalOrder) {
      int index = mixed.indexOf(node);
      mixed.removeAt(index);
      index += (node.value * decryptionKey);
      if (index < 0) {
        int x = originalOrder.length - 1;
        index += (-index ~/ x) * x + x;
      }
      if (index >= originalOrder.length) {
        index = index % (originalOrder.length - 1);
      }
      mixed.insert(index, node);
    }
  }

  int zeroIndex = mixed.indexWhere((element) => element.value == 0);
  int sum = 0;
  for (int i = 1; i <= 3; ++i) {
    int index = (zeroIndex + i * 1000) % (mixed.length);
    sum += mixed[index].value * decryptionKey;
  }
  return sum;
}
