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

  void printTreeToStringBuffer(StringBuffer buffer, [int indentCount = 0]) {
    for (int i = 0; i < indentCount * 2; ++i) {
      buffer.writeCharCode(_spaceCode);
    }
    buffer.write(name);
    buffer.writeln(' (dir)');
    indentCount++;

    for (Directory subDir in subDirectories) {
      subDir.printTreeToStringBuffer(buffer, indentCount);
    }
    for (File file in files) {
      for (int i = 0; i < indentCount * 2; ++i) {
        buffer.writeCharCode(_spaceCode);
      }
      buffer.write('- ');
      buffer.write(file.name);
      buffer.write(' (file, size=');
      buffer.write(file.size);
      buffer.writeln(')');
    }
    indentCount--;
  }
}
