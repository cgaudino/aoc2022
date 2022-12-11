import 'dart:io' as io;

import 'package:day07/directory.dart';
import 'package:day07/parser.dart';

void main(List<String> arguments) async {
  final inputFile = io.File('../../data/day07/input.txt');
  List<String> lines = await inputFile.readAsLines();

  final Directory root = Directory('/');
  final Parser parser = Parser(root);

  parser.parse(lines);

  StringBuffer treeBuffer = StringBuffer();
  root.printTreeToStringBuffer(treeBuffer);
  print(treeBuffer);

  // print(sumAllDirectoriesSmallerThan(root, 100000));

  const int driveSize = 70000000;
  const int requiredFreeSpace = 30000000;
  final int totalSize = root.calculateSize();
  final int freeSpace = driveSize - totalSize;
  final int minDirectorySize = requiredFreeSpace - freeSpace;

  int smallest =
      findSmallestDirectoryLargerThan(root, minDirectorySize, driveSize);
  print(smallest);
}

int sumAllDirectoriesSmallerThan(Directory root, final int threshold,
    [int accum = 0]) {
  final int size = root.calculateSize();
  if (size <= threshold) {
    accum += size;
  }

  for (Directory subDirectory in root.subDirectories) {
    accum = sumAllDirectoriesSmallerThan(subDirectory, threshold, accum);
  }

  return accum;
}

int findSmallestDirectoryLargerThan(
    Directory root, final int threshold, int smallest) {
  final int size = root.calculateSize();
  if (size > threshold && size < smallest) {
    smallest = size;
  }

  for (Directory subDirectory in root.subDirectories) {
    smallest =
        findSmallestDirectoryLargerThan(subDirectory, threshold, smallest);
  }

  return smallest;
}
