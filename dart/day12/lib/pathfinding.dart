class Node {
  late final Vector2 position;
  late final int height;

  // Number of steps we've taken to get to this node
  int gCost = 0;
  // Optimistic estimate of how many steps between this node and the goal
  int hCost = 0;

  int get fCost => gCost + hCost;

  List<Node> walkableNeighbors = [];

  Node(this.position);
}

/// Uses A* algorithm to find the length of the shortest path between
/// start and end.
int calculateShortestPath(Node start, Node end) {
  List<Node> searchList = [start];
  Set<Node> processedNodes = {};

  // Reset cost of start in case this node graph has already been traversed.
  // We don't need to reset other nodes here as their costs will be recalculated
  // when they are encountered and added to the search list.
  start.gCost = 0;
  start.hCost = 0;

  while (searchList.isNotEmpty) {
    // Find most likely candidate from search list
    Node current = searchList[0];
    for (Node other in searchList) {
      if (other.fCost < current.fCost ||
          (other.fCost == current.fCost && other.hCost < current.hCost)) {
        current = other;
      }
    }

    // Check if we've reach the goal
    if (current.position == end.position) {
      return current.gCost;
    }

    searchList.remove(current);
    processedNodes.add(current);

    // Consider neighbors
    for (Node neighbor in current.walkableNeighbors) {
      if (processedNodes.contains(neighbor)) {
        continue;
      }

      int neighborCost = current.gCost + 1;
      bool isNewNode = !searchList.contains(neighbor);

      if (isNewNode) {
        neighbor.gCost = neighborCost;
        Vector2 distance = end.position - neighbor.position;
        neighbor.hCost = distance.x.abs() + distance.y.abs();
        searchList.add(neighbor);
      } else if (neighborCost < neighbor.gCost) {
        neighbor.gCost = neighborCost;
      }
    }
  }

  // No valid path from start to end found
  return -1;
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
