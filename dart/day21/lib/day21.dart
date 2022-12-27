class Equation {
  late String firstOperandKey;
  late String secondOperandKey;
  late String operatorKey;

  int evaluate(int a, int b) {
    switch (operatorKey) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a ~/ b;
      default:
        throw StateError('$operatorKey is not a valid operator.');
    }
  }

  int solveForFirstOperand(int second, int result) {
    switch (operatorKey) {
      case '+':
        return result - second;
      case '-':
        return result + second;
      case '*':
        return result ~/ second;
      case '/':
        return result * second;
      default:
        throw StateError('$operatorKey is not a valid operator.');
    }
  }

  int solveForSecondOperand(int first, int result) {
    switch (operatorKey) {
      case '+':
        return result - first;
      case '-':
        return -(result - first);
      case '*':
        return result ~/ first;
      case '/':
        return first * result;
      default:
        throw StateError('$operatorKey is not a valid operator.');
    }
  }

  Equation.fromString(String string) {
    List<String> splits = string.split(' ');
    firstOperandKey = splits[0];
    operatorKey = splits[1];
    secondOperandKey = splits[2];
  }
}
