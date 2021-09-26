import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyObject {
  int uid;
  MyObject(this.uid);
}

class MyObject1 {
  int uid;
  MyObject1(this.uid);

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => uid.hashCode;
}

class MyObject2 {
  int uid;
  MyObject2(this.uid);

  @override
  bool operator ==(Object other) {
    return other is MyObject2 && uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

class ComparedClass {
  List<String> texts;
  int uid;
  int type;
  ComparedClass({
    required this.texts,
    required this.uid,
    this.type = 1,
  });

@override
bool operator ==(Object other) {
  switch (type) {
    case 2:
      return other is ComparedClass &&
          runtimeType == other.runtimeType &&
          uid == other.uid;
    case 3:
      return other is ComparedClass &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          const IterableEquality().equals(texts, other.texts);
    case 4:
      return other is ComparedClass &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          listEquals(texts, other.texts);
    case 5:
      return other is ComparedClass &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          const DeepCollectionEquality().equals(texts, other.texts);
    case 6: // cause stack overflow
      return other is ComparedClass &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(this, other);
    case 7:
      return identical(this, other);
    default:
      return other is ComparedClass && uid == other.uid;
  }
}

  @override
  int get hashCode => hashValues(hashList(texts), uid, type);
}
