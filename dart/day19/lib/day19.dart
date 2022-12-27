const int oreIndex = 0;
const int clayIndex = 1;
const int obsidianIndex = 2;
const int geodeIndex = 3;

class State {
  late List<int> resources;
  late List<int> robots;
  late List<List<int>> costs;
  late final List<int> limits;

  State() {
    resources = List.filled(geodeIndex + 1, 0);
    robots = List.filled(geodeIndex + 1, 0);
    costs = List.generate(
        geodeIndex + 1, (index) => List.filled(geodeIndex + 1, 0));
    limits = List.filled(geodeIndex + 1, 0);
  }

  State.from(State other) {
    resources = List.from(other.resources);
    robots = List.from(other.robots);
    costs = List.generate(
        other.costs.length, (index) => List.from(other.costs[index]));
    limits = other.limits;
  }
}
