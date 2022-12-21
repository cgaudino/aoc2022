class Vector2Int {
  final int x;
  final int y;

  const Vector2Int(this.x, this.y);

  @override
  Vector2Int operator +(Vector2Int b) {
    return Vector2Int(x + b.x, y + b.y);
  }

  @override
  bool operator ==(Object other) {
    return other is Vector2Int && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() {
    return '($x, $y}';
  }
}
