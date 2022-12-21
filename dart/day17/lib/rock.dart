import 'dart:collection';

import 'package:day17/vector_2_int.dart';

class Rock extends IterableMixin<Vector2Int> {
  final Iterable<Vector2Int> _parts;

  Rock(this._parts);

  @override
  Iterator<Vector2Int> get iterator => _parts.iterator;
}
