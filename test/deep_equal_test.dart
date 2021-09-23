import 'package:flutter_samples/deep_equal.dart';
import 'package:flutter_test/flutter_test.dart';

class ExtendedClass extends ComparedClass {
  String foo;
  List<String> texts;
  int uid;
  int type;

  ExtendedClass({
    required this.foo,
    required this.texts,
    required this.uid,
    this.type = 1,
  }) : super(texts: texts, uid: uid, type: type);
}

void main() {
  group('Myobject', () {
    test('should return false', () {
      final obj1 = MyObject(1);
      final obj2 = MyObject(1);
      expect(obj1 == obj2, false);
      expect(obj2 == obj1, false);
    });
  });
  group('Myobject1', () {
    test('should return true when comparing the same object', () {
      final obj1 = MyObject1(1);
      final obj2 = MyObject1(1);
      expect(obj1 == obj2, true);
      expect(obj2 == obj1, true);
    });
    test('should return true when comparing with int', () {
      final obj1 = MyObject1(1);
      final obj2 = 1;
      // ignore: unrelated_type_equality_checks
      expect(obj1 == obj2, true);
    });
    test('should return false when comparing with int (opossite order)', () {
      final obj1 = MyObject1(1);
      final obj2 = 1;
      // ignore: unrelated_type_equality_checks
      expect(obj2 == obj1, false);
    });
  });
  group('Myobject2', () {
    test('should return true when comparing the same object', () {
      final obj1 = MyObject2(1);
      final obj2 = MyObject2(1);
      expect(obj1 == obj2, true);
      expect(obj2 == obj1, true);
    });
    test('should return true when comparing with int', () {
      final obj1 = MyObject2(1);
      final obj2 = 1;
      // ignore: unrelated_type_equality_checks
      expect(obj1 == obj2, false);
    });
    test('should return false when comparing with int (opossite order)', () {
      final obj1 = MyObject2(1);
      final obj2 = 1;
      // ignore: unrelated_type_equality_checks
      expect(obj2 == obj1, false);
    });
  });
  group('Comparing objects', () {
    group('type 1', () {
      test('should return true when uid is the same', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1);
        final obj2 = ComparedClass(texts: ["1234"], uid: 1);
        expect(obj1 == obj2, true);
        expect(obj2 == obj1, true);
      });
      test('should return true when comparing with extended class', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1);
        final obj2 = ExtendedClass(foo: "2", texts: ["1234"], uid: 1);
        expect(obj1 == obj2, true);
        expect(obj2 == obj1, true);
      });
    });

    group('type2', () {
      test('should return false when comparing with extended class', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1, type: 2);
        final obj2 = ExtendedClass(foo: "2", texts: ["1234"], uid: 1, type: 2);
        expect(obj1 == obj2, false);
        expect(obj2 == obj1, false);
      });
    });
    [3, 4, 5].forEach((type) {
      group('type$type', () {
        test('should return false when list contains different item', () {
          final obj1 = ComparedClass(texts: ["123"], uid: 1, type: type);
          final obj2 = ComparedClass(texts: ["123", "22"], uid: 1, type: type);
          expect(obj1 == obj2, false);
          expect(obj2 == obj1, false);
        });
        test('should return true when list contains the same items', () {
          final obj1 = ComparedClass(texts: ["123", "22"], uid: 1, type: type);
          final obj2 = ComparedClass(texts: ["123", "22"], uid: 1, type: type);
          expect(obj1 == obj2, true);
          expect(obj2 == obj1, true);
        });
      });
    });

    group('type6', () {
      test('should return false when list contains different item', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1, type: 6);
        final obj2 = ComparedClass(texts: ["123", "22"], uid: 1, type: 6);
        expect(obj1 == obj2, false);
        expect(obj2 == obj1, false);
      });
      test('should return true when list contains the same items', () {
        final obj1 = ComparedClass(texts: ["123", "22"], uid: 1, type: 6);
        final obj2 = ComparedClass(texts: ["123", "22"], uid: 1, type: 6);
        expect(obj1 == obj2, true);
        expect(obj2 == obj1, true);
      });
    }, skip: 'this compare causes stack overflow');
    group('type7', () {
      test('should return true when the two are the same instance', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1, type: 7);
        final obj2 = obj1;
        expect(obj1 == obj2, true);
        expect(obj2 == obj1, true);
      });
      test('should return false when the two are the different instances', () {
        final obj1 = ComparedClass(texts: ["123"], uid: 1, type: 7);
        final obj2 = ComparedClass(texts: ["123"], uid: 1, type: 7);
        expect(obj1 == obj2, false);
        expect(obj2 == obj1, false);
      });
    });
  });
}
