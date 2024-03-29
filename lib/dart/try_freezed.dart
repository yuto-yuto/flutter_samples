// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'try_freezed.freezed.dart';
part 'try_freezed.g.dart';

@freezed
class FreezedA {
  factory FreezedA() = _FreezedA;
}

@freezed
class FreezedB with _$FreezedB {
  const factory FreezedB(
    final int age, {
    required final String job,
  }) = _FreezedB;
}

@unfreezed
class FreezedC with _$FreezedC {
  factory FreezedC(
    final int age, {
    required String job,
    String? remark,
  }) = _FreezedC;
}

@freezed
class FreezedD with _$FreezedD {
  factory FreezedD(int age, [@Default("nothing") String job]) = _FreezedD;
}

@freezed
class FreezedE with _$FreezedE {
  factory FreezedE(int age, {required String job}) = _FreezedE;

  factory FreezedE.fromJson(Map<String, dynamic> json) => _$FreezedEFromJson(json);
}

@freezed
class FreezedF with _$FreezedF {
  factory FreezedF({
    required Map<String, int> myMap,
    required List<int> myList,
    required Set<int> mySet,
  }) = _FreezedF;

  factory FreezedF.fromJson(Map<String, dynamic> json) => _$FreezedFFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
class FreezedG with _$FreezedG {
  factory FreezedG({
    required Map<String, int> myMap,
    required List<int> myList,
    required Set<int> mySet,
  }) = _FreezedG;

  factory FreezedG.fromJson(Map<String, dynamic> json) => _$FreezedGFromJson(json);
}

void main() {
  print("--- FreezedA ---");
  {
    final a = FreezedA();
    final b = FreezedA();
    print(a); // FreezedA()
    print(a == b); // true
    print(a.hashCode); // 64928094
    print(b.hashCode); // 64928094
  }
  print("--- FreezedB ---");
  {
    final a = FreezedB(25, job: "Programmer");
    final b = FreezedB(40, job: "Architect");
    final c = FreezedB(40, job: "Architect");
    print(a); // FreezedB(age: 25, job: Programmer)
    print(a == b); // false
    print(b == c); // true
    print(a.hashCode); // 234721650
    print(b.hashCode); // 428436564
  }
  print("--- FreezedC ---");
  {
    final a = FreezedC(25, job: "Programmer");
    final b = FreezedC(25, job: "Architect");
    print(a); // FreezedC(age: 25, job: Programmer, remark: null)
    print(b); // FreezedC(age: 25, job: Architect, remark: null)
    print(a == b); // false
    b.job = "Programmer";
    print(b); // FreezedC(age: 25, job: Programmer, remark: null)
    print(a == b); // false
    print(a.hashCode); // 1056331804
    print(b.hashCode); // 824381776
  }
  print("--- FreezedD ---");
  {
    final a = FreezedD(25, "Programmer");
    final b = FreezedD(40, "Architect");
    final c = FreezedD(40, "Architect");
    print(a); // FreezedD(age: 25, job: Programmer)
    print(a == b); // false
    print(b == c); // true
    print(a.hashCode); // 530912227
    print(b.hashCode); // 443862387
  }
  print("--- FreezedE ---");
  {
    final a = FreezedE(25, job: "Programmer");
    print(a); // FreezedE(age: 25, job: Programmer)
    final json = a.toJson();
    print(json); // {age: 25, job: Programmer}
    final b = FreezedE.fromJson(json);
    print(a == b); // true
    print(a.hashCode); // 376617188
    print(b.hashCode); // 376617188
  }
  print("--- FreezedF ---");
  {
    final a = FreezedF(
      myMap: {"one": 1, "two": 2},
      myList: [1, 2, 3],
      mySet: {9, 8, 7},
    );
    print(a); // FreezedF(myMap: {one: 1, two: 2}, myList: [1, 2, 3], mySet: {9, 8, 7})
    final json = a.toJson();
    print(json); // {myMap: {one: 1, two: 2}, myList: [1, 2, 3], mySet: [9, 8, 7]}
    final b = FreezedF.fromJson(json);
    print(a == b); // true
    print(a.hashCode); // 69584972
    print(b.hashCode); // 69584972
    // a.myList.add(4);
    // a.mySet.add(4);
    // a.myMap["1"] = 1;
  }
  print("--- FreezedG ---");
  {
    final a = FreezedG(
      myMap: {"one": 1, "two": 2},
      myList: [1, 2, 3],
      mySet: {9, 8, 7},
    );
    print(a.hashCode); // 410623709
    a.myList.add(4);
    a.mySet.add(4);
    a.myMap["1"] = 1;
    print(a); // FreezedG(myMap: {one: 1, two: 2, 1: 1}, myList: [1, 2, 3, 4], mySet: {9, 8, 7, 4})
    final json = a.toJson();
    print(json); // {myMap: {one: 1, two: 2, 1: 1}, myList: [1, 2, 3, 4], mySet: [9, 8, 7, 4]}
    final b = FreezedG.fromJson(json);
    print(a == b); // true
    print(a.hashCode); // 20025643
    print(b.hashCode); // 20025643
  }
}
