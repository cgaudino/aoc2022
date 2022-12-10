import 'dart:io';

const int drawPoints = 3;
const int victoryPoints = 6;

const int loseCode = 0;
const int winCode = 2;

const List<int> winTable = [2, 0, 1];

void main(List<String> arguments) async {
  final file = File('../../data/day02/input.txt');
  final List<String> lines = await file.readAsLines();

  final int aOffset = "A".codeUnitAt(0);
  final int xOffset = "X".codeUnitAt(0);

  int score = 0;

  for (String line in lines) {
    assert(line.length == 3);

    final int desiredOutcome = line.codeUnitAt(2) - xOffset;
    final int opponentShape = line.codeUnitAt(0) - aOffset;

    int playerShape = opponentShape;
    if (desiredOutcome == loseCode) {
      playerShape = winTable[opponentShape];
    } else if (desiredOutcome == winCode) {
      playerShape = winTable.indexOf(opponentShape);
    }

    score += playerShape + 1;

    if (opponentShape == playerShape) {
      score += drawPoints;
    } else if (opponentShape == winTable[playerShape]) {
      score += victoryPoints;
    }
  }

  print(score);
}
