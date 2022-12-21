import 'dart:math';

class Vector3Int {
  final int x;
  final int y;
  final int z;

  const Vector3Int(this.x, this.y, this.z);

  Vector3Int operator +(Vector3Int other) {
    return Vector3Int(x + other.x, y + other.y, z + other.z);
  }

  @override
  int get hashCode => Object.hash(x, y, z);

  bool operator ==(Object other) {
    return other is Vector3Int && x == other.x && y == other.y && z == other.z;
  }

  static Vector3Int? tryParse(String input) {
    List<String> splits = input.split(',');
    if (splits.length != 3) {
      return null;
    }

    int? x = int.tryParse(splits[0]);
    int? y = int.tryParse(splits[1]);
    int? z = int.tryParse(splits[2]);

    if (x == null || y == null || z == null) {
      return null;
    }

    return Vector3Int(x, y, z);
  }
}

class BoundingBox {
  late int _minX;
  late int _minY;
  late int _minZ;

  late int _maxX;
  late int _maxY;
  late int _maxZ;

  bool _isInitialized = false;

  void envelop(Vector3Int coord) {
    if (!_isInitialized) {
      _minX = _maxX = coord.x;
      _minY = _maxY = coord.y;
      _minZ = _maxZ = coord.z;
      _isInitialized = true;
      return;
    }

    _minX = min(_minX, coord.x);
    _minY = min(_minY, coord.y);
    _minZ = min(_minZ, coord.z);

    _maxX = max(_maxX, coord.x);
    _maxY = max(_maxY, coord.y);
    _maxZ = max(_maxZ, coord.z);
  }

  bool contains(Vector3Int coord) {
    return coord.x >= _minX &&
        coord.x <= _maxX &&
        coord.y >= _minY &&
        coord.y <= _maxY &&
        coord.z >= _minZ &&
        coord.z <= _maxZ;
  }
}
