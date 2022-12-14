import 'dart:math';

import 'package:day12/pathfinding.dart';

class World {
  late Vector2 _min;
  late Vector2 _max;

  late final List<List<int>> _map;

  static const int emptyValue = 0;
  static const int wallValue = 1;
  static const int sandValue = 2;

  World(List<String> serializedMap, bool isInfinite) {
    _deserializeMap(serializedMap, isInfinite);
  }

  bool sandFallsToInfinity(Vector2 position) {
    position = Vector2(position.x - _min.x, position.y - _min.y);
    while (position.y < _max.y) {
      // Down
      if (_map[position.y + 1][position.x] == 0) {
        position = Vector2(position.x, position.y + 1);
        continue;
      }
      // Diagonal left
      if (position.x - 1 < 0) {
        break;
      }
      if (_map[position.y + 1][position.x - 1] == 0) {
        position = Vector2(position.x - 1, position.y + 1);
        continue;
      }
      // Diagonal right
      if (position.x + 1 >= _map[position.y + 1].length) {
        break;
      }
      if (_map[position.y + 1][position.x + 1] == 0) {
        position = Vector2(position.x + 1, position.y + 1);
        continue;
      }
      _map[position.y][position.x] = sandValue;
      return false;
    }
    return true;
  }

  Vector2 getSandRestPosition(Vector2 startPosition) {
    Vector2 position =
        Vector2(startPosition.x - _min.x, startPosition.y - _min.y);
    while (position.y < _max.y) {
      // Down
      if (_map[position.y + 1][position.x] == 0) {
        position = Vector2(position.x, position.y + 1);
        continue;
      }
      // Diagonal left
      if (position.x - 1 < 0) {
        _growLeft();
        position = Vector2(startPosition.x - _min.x, startPosition.y - _min.y);
      }
      if (_map[position.y + 1][position.x - 1] == 0) {
        position = Vector2(position.x - 1, position.y + 1);
        continue;
      }
      // Diagonal right
      if (position.x + 1 >= _map[position.y + 1].length) {
        _growRight();
        position = Vector2(startPosition.x - _min.x, startPosition.y - _min.y);
      }
      if (_map[position.y + 1][position.x + 1] == 0) {
        position = Vector2(position.x + 1, position.y + 1);
        continue;
      }
      _map[position.y][position.x] = sandValue;
      return Vector2(position.x + _min.x, position.y + _min.y);
    }
    return Vector2(0, 0);
  }

  void _deserializeMap(List<String> serializedMap, bool isInfinite) {
    List<List<Vector2>> vectors = serializedMap.map((line) {
      return line.split('->').map((e) {
        List<String> components = e.split(',');
        return Vector2(
            int.parse(components[0].trim()), int.parse(components[1].trim()));
      }).toList();
    }).toList();

    _min = Vector2(999999, 0);
    _max = Vector2(-99999, -99999);
    for (Iterable<Vector2> vector in vectors) {
      for (Vector2 point in vector) {
        if (point.x < _min.x) {
          _min = Vector2(point.x, _min.y);
        }
        if (point.y < _min.y) {
          _min = Vector2(_min.x, point.y);
        }
        if (point.x > _max.x) {
          _max = Vector2(point.x, _max.y);
        }
        if (point.y > _max.y) {
          _max = Vector2(_max.x, point.y);
        }
      }
    }

    if (!isInfinite) {
      _max = Vector2(_max.x, _max.y + 2);
    }

    _map = List.generate(
      _max.y - _min.y + 1,
      (index) =>
          List.filled(_max.x - _min.x + 1, emptyValue, growable: !isInfinite),
    );

    for (List<Vector2> vector in vectors) {
      for (int i = 0; i < vector.length - 1; ++i) {
        _addWall(vector[i], vector[i + 1]);
      }
    }
    if (!isInfinite) {
      _addWall(Vector2(_min.x, _max.y), _max);
    }
  }

  void _addWall(Vector2 start, Vector2 end) {
    assert(start.x == end.x || start.y == end.y);
    final Vector2 difference = end - start;
    final Vector2 increment = Vector2(difference.x.sign, difference.y.sign);
    int iterations = max(difference.x.abs(), difference.y.abs()) + 1;
    for (int i = 0; i < iterations; ++i) {
      Vector2 position = start + Vector2(increment.x * i, increment.y * i);
      _map[position.y - _min.y][position.x - _min.x] = wallValue;
    }
  }

  void _growLeft() {
    int width = _max.x - _min.x;
    _min = Vector2(_min.x - width, _min.y);
    for (List<int> row in _map) {
      row.insertAll(0, Iterable.generate(width, (index) => emptyValue));
    }
    _addWall(Vector2(_min.x, _max.y), _max);
  }

  void _growRight() {
    int width = _max.x - _min.x;
    _max = Vector2(_max.x + width, _max.y);
    for (List<int> row in _map) {
      row.addAll(Iterable.generate(width, (index) => emptyValue));
    }
    _addWall(Vector2(_min.x, _max.y), _max);
  }

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer();

    for (int y = 0; y < _map.length; ++y) {
      for (int x = 0; x < _map[y].length; ++x) {
        switch (_map[y][x]) {
          case 0:
            buffer.write('.');
            break;
          case 1:
            buffer.write('#');
            break;
          case 2:
            buffer.write('O');
            break;
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
