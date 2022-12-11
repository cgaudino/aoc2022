import 'dart:io';

void main(List<String> arguments) async {
  final file = File('../../data/day09/input.txt');
  List<String> lines = await file.readAsLines();

  const Map<String, Vector2> directionMap = <String, Vector2>{
    'L': Vector2(-1, 0),
    'R': Vector2(1, 0),
    'U': Vector2(0, 1),
    'D': Vector2(0, -1),
  };

  const int ropeLength = 10;

  List<Vector2> rope = List.filled(ropeLength, Vector2(0, 0));
  Set<Vector2> visited = {Vector2(0, 0)};

  printGrid(rope);

  for (String line in lines) {
    List<String> splits = line.split(' ');
    assert(splits.length == 2);

    Vector2 headDirection = directionMap[splits[0]]!;
    int count = int.parse(splits[1]);

    print('== $line ==');
    print('');

    for (int i = 0; i < count; ++i) {
      rope[0] += headDirection;
      for (int k = 0; k < rope.length - 1; ++k) {
        Vector2 distance = rope[k] - rope[k + 1];
        if (distance.x.abs() < 2 && distance.y.abs() < 2) {
          break;
        }
        rope[k + 1] = rope[k + 1] + Vector2(distance.x.sign, distance.y.sign);
      }
      visited.add(rope.last);
    }
    printGrid(rope);
  }

  print(visited.length);
}

void printGrid(List<Vector2> rope) {
  StringBuffer buffer = StringBuffer();
  for (int y = 10; y >= -10; --y) {
    for (int x = -15; x < 15; ++x) {
      final Vector2 coordinate = Vector2(x, y);
      int index = rope.indexOf(coordinate);
      if (index == 0) {
        buffer.write('H');
      } else if (index == rope.length - 1) {
        buffer.write('T');
      } else if (index > 0 && index < rope.length) {
        buffer.write(index);
      } else {
        buffer.write('.');
      }
    }
    buffer.writeln();
  }
  buffer.writeln();
  print(buffer);
}

class Vector2 {
  final int x;
  final int y;

  const Vector2(this.x, this.y);

  Vector2 operator +(Vector2 v) => Vector2(x + v.x, y + v.y);
  Vector2 operator -(Vector2 v) => Vector2(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector2 && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() {
    return '($x, $y)';
  }
}
