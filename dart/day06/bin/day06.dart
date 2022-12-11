import 'dart:io';
import 'dart:typed_data';

void main(List<String> arguments) async {
  final file = File('../../data/day06/input.txt');
  String string = await file.readAsString();
  List<int> characters = string.codeUnits;

  // const int markerLength = 4;
  const int markerLength = 14;

  final Set<int> usedCharacters = {};
  for (int i = 0; i < characters.length - markerLength; ++i) {
    usedCharacters.clear();
    bool doesRepeat = false;
    for (int x = 0; x < markerLength; ++x) {
      int char = characters[i + x];
      if (usedCharacters.contains(char)) {
        doesRepeat = true;
        break;
      }
      usedCharacters.add(char);
    }
    if (!doesRepeat) {
      print(i + markerLength);
      break;
    }
  }
}
