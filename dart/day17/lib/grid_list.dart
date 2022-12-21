import 'package:day17/vector_2_int.dart';

class GridList<E> {
  final List<E> _list = [];

  late final E _defaultValue;
  late final int _width;

  int get width => _width;
  int get height => _list.length ~/ _width;
  List<E> get data => _list;

  GridList(this._width, this._defaultValue) {
    if (_width < 1) {
      throw StateError('GridList width must be greater than 0');
    }
  }

  E operator [](Vector2Int coord) {
    int index = _coordToIndex(coord);
    if (index < 0 || index >= _list.length) {
      return _defaultValue;
    }
    return _list[index];
  }

  void operator []=(Vector2Int coord, E value) {
    int index = _coordToIndex(coord);
    if (index < 0) {
      throw StateError('GridList does not support negative coordinates.');
    }
    while (index >= _list.length) {
      for (int i = 0; i < _width; ++i) {
        _list.add(_defaultValue);
      }
    }
    _list[index] = value;
  }

  int _coordToIndex(Vector2Int coord) => coord.y * _width + coord.x;

  @override
  String toString() {
    const String defaultValueChar = '.';
    const String otherValueChar = '#';

    StringBuffer buffer = StringBuffer();

    for (int y = height - 1; y >= 0; --y) {
      buffer.write('|');
      for (int x = 0; x < width; ++x) {
        if (this[Vector2Int(x, y)] == _defaultValue) {
          buffer.write(defaultValueChar);
        } else {
          buffer.write(otherValueChar);
        }
      }
      buffer.writeln('|');
    }

    buffer.write('+');
    for (int x = 0; x < width; ++x) {
      buffer.write('-');
    }
    buffer.writeln('+');

    return buffer.toString();
  }
}
