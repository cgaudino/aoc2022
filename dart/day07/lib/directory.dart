import 'package:day07/file.dart';

class Directory {
  late final String name;
  Directory? parent;

  final List<File> files = [];
  final List<Directory> subDirectories = [];

  Directory get root => parent?.root ?? this;

  Directory(this.name);

  int calculateSize() {
    int totalSize = 0;
    for (final file in files) {
      totalSize += file.size;
    }
    for (final subDir in subDirectories) {
      totalSize += subDir.calculateSize();
    }
    return totalSize;
  }

  final int _spaceCode = ' '.codeUnitAt(0);

  void printTree([int indentCount = 0]) {
    String indent =
        String.fromCharCodes(List<int>.filled(indentCount * 2, _spaceCode));
    print('$indent- $name (dir)');
    indentCount++;
    indent =
        String.fromCharCodes(List<int>.filled(indentCount * 4, _spaceCode));
    for (Directory subDir in subDirectories) {
      subDir.printTree(indentCount);
    }
    for (File file in files) {
      print("$indent- ${file.name} (file, size=${file.size})");
    }
    indentCount--;
  }
}
