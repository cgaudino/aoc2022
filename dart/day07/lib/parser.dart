import 'package:day07/directory.dart';
import 'package:day07/file.dart';

class Parser {
  static const String commandPrompt = '\$ ';
  static const String cdCommand = 'cd';
  static const String lsCommand = 'ls';

  late final Directory root;
  late Directory pwd;

  int head = 0;

  Parser(this.root) {
    pwd = root;
  }

  void parse(List<String> lines) {
    assert(lines[0].startsWith(commandPrompt));
    head = 0;

    while (head < lines.length) {
      _parseCommand(lines);
    }
  }

  void _parseCommand(List<String> lines) {
    List<String> tokens = lines[head++].split(' ');
    switch (tokens[1]) {
      case cdCommand:
        assert(tokens.length == 3);
        _changeDirectory(tokens[2]);
        break;
      case lsCommand:
        _parseLsOutput(lines);
        break;
      default:
        print('encountered unknown command ${tokens[1]}');
        break;
    }
  }

  void _changeDirectory(String commandArgument) {
    const String parentAlias = '..';

    if (commandArgument == root.name) {
      pwd = root;
      return;
    } else if (commandArgument == parentAlias) {
      pwd = pwd.parent ?? root;
      return;
    }

    pwd = _getOrCreateSubdirectory(commandArgument);
  }

  void _parseLsOutput(List<String> lines) {
    const String directoryPrefix = 'dir';

    while (head < lines.length && !lines[head].startsWith(commandPrompt)) {
      String line = lines[head];
      if (line.startsWith(directoryPrefix)) {
        String dirName = line.substring(directoryPrefix.length + 1);
        _getOrCreateSubdirectory(dirName);
      } else {
        List<String> fileElements = line.split(' ');
        assert(fileElements.length == 2);
        if (!pwd.files.any((f) => f.name == fileElements[1])) {
          File file = File();
          file.size = int.parse(fileElements[0]);
          file.name = fileElements[1];
          pwd.files.add(file);
        }
      }
      head++;
    }
  }

  Directory _getOrCreateSubdirectory(String name) {
    for (Directory s in pwd.subDirectories) {
      if (s.name == name) {
        return s;
      }
    }

    Directory subDirectory = Directory(name);
    subDirectory.parent = pwd;
    pwd.subDirectories.add(subDirectory);
    return subDirectory;
  }
}
