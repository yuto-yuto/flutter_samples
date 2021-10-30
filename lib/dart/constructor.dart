void _printPoint(_Point point) {
  print("${point.hashCode}: [${point.x}, ${point.y}, ${point.z}]");
}

class _Point {
  double x = 0;
  double y = 0;
  double? z;

  _Point();
  // _Point(this.x, this.y);
  _Point.create(double x, double y) {
    this.x = x;
    this.y = y;
  }
  _Point.power(double x, double y) {
    this.x = x * x;
    this.y = y * y;
  }
  _Point.create2(this.x, this.y);
  _Point.named({
    required this.x,
    required this.y,
    this.z,
  });
  _Point.named2({
    required this.x,
    this.y = 10,
    this.z = 5,
  });
  _Point.create4(this.x, this.y, this.z);
  _Point.positional(this.x, this.y, [this.z]);
  _Point.positional2(double x, [double? y, double? z]) {
    this.x = x;
    this.y = y ?? 0;
    this.z = z ?? 0;
  }
  _Point.positional3(double x, [double y = 0, double z = 0]) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  _Point.origin() {
    _Point.create4(0, 0, 0);
  }
  _Point.origin2() : this.create4(0, 0, 0);
  _Point.initializer(double value)
      : x = value + 1,
        y = value + 2,
        z = value * value;
  _Point.initializer2(double value)
      : x = value + 1,
        y = value + 2 {
    z = y;
  }
}

void _printLine(_Line line) {
  print("${line.hashCode}:"
      "[(${line.startPoint.x}, ${line.startPoint.y}), "
      "(${line.endPoint.x}, ${line.endPoint.y})]");
}

class _Line {
  final _Point startPoint;
  late final _Point endPoint;
  _Line._internal(this.startPoint, this.endPoint);
  _Line.horizontal({
    required this.startPoint,
    required double length,
  }) {
    endPoint = _Point.create(length, 0);
  }
  factory _Line.vertical(double length) {
    final start = _Point.create(0, 0);
    
    if (length > 10) {
      length = 10;
    }
    final end = _Point.create(0, length);
    return _Line._internal(start, end);
  }
  initEndPoint() {
    // runtime error!!
    endPoint = _Point.origin2();
  }
}

class _ImmutableDataHolder {
  final int uid;
  final String name;
  const _ImmutableDataHolder({
    required this.uid,
    required this.name,
  });
}

void main() {
  print("---- point ----");
  _printPoint(_Point());
  // _printPoint(_Point(5, 5));
  _printPoint(_Point.create(1, 1));
  _printPoint(_Point.create2(1, 1));
  _printPoint(_Point.power(5, 5));
  print("---- named ----");
  _printPoint(_Point.named(x: 1, y: 1));
  _printPoint(_Point.named(x: 1, y: 1, z: 1));
  _printPoint(_Point.named(y: 1, x: 2));
  _printPoint(_Point.named(y: 1, z: 2, x: 3));
  _printPoint(_Point.create4(1, 1, 1));
  print("---- positional ----");
  _printPoint(_Point.positional(1, 2));
  _printPoint(_Point.positional(1, 2, 3));
  _printPoint(_Point.positional2(1));
  print("---- default value ----");
  _printPoint(_Point.named2(x: 1));
  _printPoint(_Point.positional3(1));

  print("---- Redirect ----");
  _printPoint(_Point.origin());
  _printPoint(_Point.origin2());

  print("---- Initializer ----");
  _printPoint(_Point.initializer(9));
  _printPoint(_Point.initializer2(9));

  print("---- line ----");
  final start = _Point.positional(0, 0);
  final instance = _Line.horizontal(startPoint: start, length: 5);
  _printLine(instance);
  // instance.initEndPoint(); // error
  _printLine(_Line.vertical(9));

  var first = const _ImmutableDataHolder(uid: 1, name: "yuto");
  var second = const _ImmutableDataHolder(uid: 1, name: "yuto");
  var third = _ImmutableDataHolder(uid: 1, name: "yuto");
  print(identical(first, second)); // true
  print(identical(first, third)); // false
  print("first:  ${first.hashCode},\n"
      "second: ${second.hashCode},\n"
      "third:  ${third.hashCode}");
//  first:  775314292,
//  second: 775314292,
//  third:  108382137
}
