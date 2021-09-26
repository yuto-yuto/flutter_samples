import 'package:flutter_test/flutter_test.dart';

void main() {
  group('throw test for ArgumentError', () {
    Never throwError() {
      throw ArgumentError(
        "Error message.",
        "invalidName",
      );
    }

    test('should throw ArgumentError', () {
      expect(throwError, throwsA(isInstanceOf<ArgumentError>()));
      expect(throwError, throwsA(isA<ArgumentError>()));
      expect(throwError, throwsA(predicate((x) => x is ArgumentError)));
      expect(throwError, throwsA(isArgumentError));
    });

    test('should throw ArgumentError with message', () {
      expect(
          throwError,
          throwsA(
            isArgumentError.having(
              (x) => x.message,
              "my message",
              contains("Error"),
            ),
          ));
      expect(
          throwError,
          throwsA(
            predicate(
              (x) => x is ArgumentError && x.message == "Error message.",
            ),
          ));
    });
    test('should throw ArgumentError with invalid value and property name', () {
      expect(
          throwError,
          throwsA(
            predicate(
              (x) => x is ArgumentError && x.name == "invalidName",
            ),
          ));
    });
  });

  group('throw test for ArgumentError.value', () {
    Never throwErrorValue() {
      throw ArgumentError.value(
        "invalid-string",
        "invalidName",
        "Error message.",
      );
    }

    test('should throw ArgumentError', () {
      expect(throwErrorValue, throwsA(isInstanceOf<ArgumentError>()));
      expect(throwErrorValue, throwsA(isA<ArgumentError>()));
      expect(throwErrorValue, throwsA(predicate((x) => x is ArgumentError)));
      expect(throwErrorValue, throwsA(isArgumentError));
    });

    test('should throw ArgumentError with message', () {
      expect(
          throwErrorValue,
          throwsA(
            predicate(
              (x) => x is ArgumentError && x.message == "Error message.",
            ),
          ));
    });
    test('should throw ArgumentError with invalid value and property name', () {
      expect(
          throwErrorValue,
          throwsA(
            predicate(
              (x) =>
                  x is ArgumentError &&
                  x.invalidValue == "invalid-string" &&
                  x.name == "invalidName",
            ),
          ));
    });
  });
}
