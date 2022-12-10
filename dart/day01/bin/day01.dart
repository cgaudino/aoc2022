import 'dart:io';

const int numSums = 3;

void main(List<String> arguments) async {
  final file = File('../../data/day01/input.txt');
  final List<String> lines = await file.readAsLines();

  final int sum = calculateSums(lines, numSums);
  print(sum);
}

int calculateSums(List<String> lines, int numSums) {
  final List<int> sums = List.filled(numSums, 0);
  int accum = 0;
  for (String line in lines) {
    if (line.isEmpty) {
      insertOrdered(sums, accum);
      accum = 0;
      continue;
    }

    accum += int.parse(line);
  }

  int total = 0;
  for (int sum in sums) {
    total += sum;
  }

  return total;
}

void insertOrdered(List<int> list, int newValue) {
  for (int i = 0; i < list.length; i++) {
    if (newValue > list[i]) {
      int temp = list[i];
      list[i] = newValue;
      newValue = temp;
    }
  }
}
