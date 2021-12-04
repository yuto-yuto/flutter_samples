import 'package:intl/intl.dart';

void main() {
  final values = [
    0.0,
    1,
    -1.23456,
    123456.0,
  ];

for (final value in values) {
  print("$value\t: toStringAsPrecision: ${value.toStringAsPrecision(4)}");
}
print("");

for (final value in values) {
  print("$value\t: toStringAsFixed: ${value.toStringAsFixed(4)}");
}
  print("");

  for (final value in values) {
    final isNotZero = (value - value.truncate()) != 0;
    final isNotZero2 = value.truncateToDouble() != value;
    print(
        "$value\t: min number of digit: ${isNotZero2 ? value : value.toInt()}");
  }
  print("");

  for (final value in [...values, 10.50, -10.5, 10.00]) {
    print("$value\t: NumberFormat: ${new NumberFormat("0.##").format(value)}");
  }
  print("");

  for (final value in [...values, 10.50, -10.5, 10.00]) {
    final currency =
        new NumberFormat.currency(name: "EUR", symbol: "€").format(value);
    print("$value\t: currency: $currency");
  }
  print("");

for (final value in [...values, 10.50, 10.5, 10.00]) {
  final isZero = value.truncateToDouble() == value;
  print("$value\t: currency2: ${value.toStringAsFixed(isZero ? 0 : 2)}");
}
  print("");

  for (final value in values) {
    print("$value\t: ceilToDouble ${value.ceilToDouble()}");
  }
  print("");

  for (final value in values) {
    print("$value\t: truncateToDouble ${value.truncateToDouble()}");
  }
  print("");

  for (final value in [1.4, 1.5, -0.4, -0.5, 1.05]) {
    print("$value\t: roundToDouble ${value.roundToDouble()}");
  }
  print("");
}
