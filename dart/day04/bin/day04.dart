import 'dart:io';
import 'dart:math';

void main(List<String> arguments) async {
  final file = File('../../data/day04/input.txt');
  final List<String> lines = await file.readAsLines();

  int count = 0;
  for (String line in lines) {
    List<String> ranges = line.split(',');
    assert(ranges.length == 2);

    Range a = Range(ranges[0]);
    Range b = Range(ranges[1]);

    // if (a.envelops(b) || b.envelops(a)) {
    //   count++;
    // }
    if (a.overlaps(b)) {
      count++;
    }
  }

  print(count);
}

class Range {
  late final int lowerBound;
  late final int upperBound;

  Range(String rangeString) {
    List<String> bounds = rangeString.split('-');
    assert(bounds.length == 2);

    lowerBound = int.parse(bounds[0]);
    upperBound = int.parse(bounds[1]);
  }

  bool envelops(Range other) {
    return lowerBound <= other.lowerBound && upperBound >= other.upperBound;
  }

  bool overlaps(Range other) {
    final int middleLower = max(lowerBound, other.lowerBound);
    final int middleUpper = min(upperBound, other.upperBound);

    return middleLower <= middleUpper || middleUpper >= middleLower;
  }
}
