import 'dart:io';
import 'dart:math';

const int visibilityLeftFlag = 1 << 0;
const int visibilityRightFlag = 1 << 1;
const int visibilityUpFlag = 1 << 2;
const int visibilityDownFlag = 1 << 3;

void main(List<String> arguments) async {
  final file = File('../../data/day08/input.txt');
  List<String> lines = await file.readAsLines();

  List<List<int>> trees =
      List.generate(lines.length, (i) => lines[i].codeUnits, growable: false);

  print(calculateNumTreesVisible(trees));
  print(findMaxTreeScore(trees));
}

int calculateNumTreesVisible(List<List<int>> trees) {
  List<List<int>> visibility = List.generate(
      trees.length, (i) => List.filled(trees[i].length, 0),
      growable: false);

  calculateVisibilityHorizontal(trees, visibility, 1, visibilityLeftFlag);
  calculateVisibilityHorizontal(trees, visibility, -1, visibilityRightFlag);
  calculateVisibilityVertical(trees, visibility, 1, visibilityDownFlag);
  calculateVisibilityVertical(trees, visibility, -1, visibilityUpFlag);

  int visibleTrees = 0;
  for (List<int> row in visibility) {
    visibleTrees += row.where((isVisible) => isVisible != 0).length;
  }
  return visibleTrees;
}

void calculateVisibilityHorizontal(List<List<int>> trees,
    List<List<int>> visibility, int direction, int visibilityFlag) {
  for (int r = 0; r < trees.length; ++r) {
    List<int> treeRow = trees[r];

    final int startIndex = direction > 0 ? 0 : treeRow.length - 1;
    final int lastIndex = direction > 0 ? treeRow.length - 1 : 0;
    final int lowerBound = min(startIndex, lastIndex);
    final int upperBound = max(startIndex, lastIndex);

    for (int c = startIndex;
        c >= lowerBound && c <= upperBound;
        c += direction) {
      int height = trees[r][c];
      bool isVisible = true;

      for (int n = c + -direction;
          n >= lowerBound && n <= upperBound;
          n -= direction) {
        if (trees[r][n] >= height) {
          isVisible = false;
          break;
        }
      }

      if (isVisible) {
        visibility[r][c] = visibility[r][c] | visibilityFlag;
      }
    }
  }
}

void calculateVisibilityVertical(List<List<int>> trees,
    List<List<int>> visibility, int direction, int visibilityFlag) {
  int width = trees[0].length;
  for (int c = 0; c < width; ++c) {
    final int startIndex = direction > 0 ? 0 : trees.length - 1;
    final int lastIndex = direction > 0 ? trees.length - 1 : 0;
    final int lowerBound = min(startIndex, lastIndex);
    final int upperBound = max(startIndex, lastIndex);

    for (int r = startIndex;
        r >= lowerBound && r <= upperBound;
        r += direction) {
      int height = trees[r][c];
      bool isVisible = true;

      for (int n = r + -direction;
          n >= lowerBound && n <= upperBound;
          n -= direction) {
        if (trees[n][c] >= height) {
          isVisible = false;
          break;
        }
      }

      if (isVisible) {
        visibility[r][c] = visibility[r][c] | visibilityFlag;
      }
    }
  }
}

int findMaxTreeScore(List<List<int>> trees) {
  List<List<int>> scores = List.generate(
      trees.length, (i) => List.filled(trees[i].length, 0),
      growable: false);

  for (int r = 0; r < scores.length; r++) {
    for (int c = 0; c < scores[r].length; c++) {
      scores[r][c] = calculateTreeScore(trees, r, c);
    }
  }

  return scores
      .map((list) => list.reduce((m, v) => max(m, v)))
      .reduce((m, v) => max(m, v));
}

int calculateTreeScore(List<List<int>> trees, final int r, final int c) {
  final int height = trees[r][c];

  int left = 0;
  for (int i = c - 1; i >= 0; --i) {
    left += 1;
    if (trees[r][i] >= height) break;
  }

  int right = 0;
  for (int i = c + 1; i < trees[r].length; ++i) {
    right += 1;
    if (trees[r][i] >= height) break;
  }

  int down = 0;
  for (int i = r + 1; i < trees.length; ++i) {
    down += 1;
    if (trees[i][c] >= height) break;
  }

  int up = 0;
  for (int i = r - 1; i >= 0; --i) {
    up += 1;
    if (trees[i][c] >= height) break;
  }

  return left * right * down * up;
}
