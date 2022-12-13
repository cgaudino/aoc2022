import 'dart:io';
import 'package:day12/pathfinding.dart';

final int startChar = 'S'.codeUnitAt(0);
final int startHeight = 'a'.codeUnitAt(0);
final int endChar = 'E'.codeUnitAt(0);
final int endHeight = 'z'.codeUnitAt(0);

void main(List<String> arguments) async {
  final file = File('../../data/day12/input.txt');
  List<String> lines = await file.readAsLines();

  // Parse node graph
  late Node start;
  late Node end;
  List<List<Node>> nodes = List.generate(lines.length, (y) {
    return List.generate(lines[y].length, (x) {
      Node node = Node(Vector2(x, y));

      int char = lines[y].codeUnitAt(x);

      if (char == startChar) {
        start = node;
        node.height = startHeight;
      } else if (char == endChar) {
        end = node;
        node.height = endHeight;
      } else {
        node.height = char;
      }
      return node;
    });
  });

  // Calculate walkability for each node
  const List<Vector2> offsets = [
    Vector2(-1, 0),
    Vector2(1, 0),
    Vector2(0, 1),
    Vector2(0, -1)
  ];
  for (int y = 0; y < nodes.length; ++y) {
    for (int x = 0; x < nodes[y].length; ++x) {
      for (Vector2 offset in offsets) {
        Node node = nodes[y][x];
        Vector2 np = node.position + offset;
        if (np.x >= 0 &&
            np.y >= 0 &&
            np.y <= nodes.length - 1 &&
            np.x <= nodes[np.y].length - 1 &&
            nodes[np.y][np.x].height - node.height < 2) {
          node.walkableNeighbors.add(nodes[np.y][np.x]);
        }
      }
    }
  }

  // Part 1
  int part1Result = calculateShortestPath(start, end);
  print('Part One: $part1Result');

  // Part 2
  int part2Result = part1Result;
  for (List<Node> row in nodes) {
    for (Node node in row) {
      if (node.height > startHeight) {
        continue;
      }
      int distance = calculateShortestPath(node, end);
      if (distance > 0 && distance < part2Result) {
        part2Result = distance;
      }
    }
  }
  print('Part Two: $part2Result');
}
