import 'dart:math';

void main() {
  final random = new Random();
  final loopCount = 10;

  print("Bool\tInt\tDouble");
  print("----------------------------------------");
  for (var i = 0; i < loopCount; i++) {
    final boolValue = random.nextBool();
    final intValue = random.nextInt(100);
    final doubleValue = random.nextDouble();
    print("$boolValue\t$intValue\t$doubleValue");
  }

  print("----------------------------------------");
  for (var i = 0; i < loopCount; i++) {
    print(Random(2).nextInt(100));
  }

  print("---------------- secure ------------------------");
  final secure = Random.secure();
  for (var i = 0; i < loopCount; i++) {
    print(secure.nextInt(100));
  }

  print("---------------- min - max int ------------------------");

  final min = 30;
  final max = 100;
  for (var i = 0; i < loopCount; i++) {
    print(min + random.nextInt(max - min));
  }

  print("----------------------------------------");

  for (var i = 0; i < loopCount; i++) {
    print(random.nextInt(1000) * 0.01);
  }

  print("------------------???----------------------");
  for (var i = 0; i < loopCount + 40; i++) {
    double value = random.nextDouble() * 10;
    value = double.parse(value.toStringAsFixed(2));
    print(value);
  }

  print("----------------  _generateDouble  ------------------------");
  for (var i = 0; i < loopCount + 40; i++) {
    final value = _generateDouble(5.51, 11.234, 3);
    if (value < 5.51 || value > 11.234) {
      print("Failed: $value");
    }
  }
  print("---------------  _generateDouble2 -------------------------");
  for (var i = 0; i < loopCount + 40; i++) {
    final value = _generateDouble2(4.1, 10.432, 4);
    print("$value");
  }
}

double _generateDouble(double minValue, double maxValue, int precision) {
  final minValues = minValue.toString().split(".");
  final maxValues = maxValue.toString().split(".");

  final maxLengthAfterDecimalPoint = max(
    minValues[1].length,
    maxValues[1].length,
  );

  // e.g. min 5.51, max 11.234
  // -->  5510    , 11234
  final intMin = minValue * pow(10, maxLengthAfterDecimalPoint);
  final intMax = maxValue * pow(10, maxLengthAfterDecimalPoint);

  final random = new Random();
  final intRandom =
      intMin.toInt() + random.nextInt(intMax.toInt() - intMin.toInt());

  final doubleRandom = intRandom * pow(0.1, maxLengthAfterDecimalPoint);
  return double.parse(doubleRandom.toStringAsFixed(precision));
}

double _generateDouble2(double minValue, double maxValue, int precision) {
  final random = new Random();
  final doubleRandom = minValue + (maxValue - minValue) * random.nextDouble();
  return double.parse(doubleRandom.toStringAsFixed(precision));
}
