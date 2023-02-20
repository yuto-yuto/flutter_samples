import 'dart:convert';
import 'dart:developer';

void main() {
  _distinct();
}

extension ListExtensions<T> on List<T> {
  Iterable<T> whereWithIndex(bool test(T element, int index)) {
    final List<T> result = [];
    for (var i = 0; i < this.length; i++) {
      if (test(this[i], i)) {
        result.add(this[i]);
      }
    }
    return result;
  }

  // Iterable<T> distinct(){}
}

class _Product {
  final name;
  final type;
  final price;
  _Product({
    required this.name,
    required this.type,
    required this.price,
  });

  String toJson() {
    return "{ name: $name, type: $type, price: $price}";
  }

  @override
  bool operator ==(Object other) {
    return other is _Product && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(name, type, price);
}

void _distinct() {
  final list = [1, 2, 3, 4, 1, 2, 3, 4, 5];

  {
    final result = list.toSet().toList();
    print(result); // [1, 2, 3, 4, 5]
  }

  {
    final result = list.whereWithIndex((element, index) => list.indexOf(element) == index);
    print(result); // [1, 2, 3, 4, 5]
  }

  final products = [
    _Product(name: "USB", type: "A", price: 10),
    _Product(name: "USB", type: "A", price: 10),
    _Product(name: "USB", type: "B", price: 12),
    _Product(name: "USB", type: "C", price: 11),
    _Product(name: "Mouse", type: "A", price: 10),
    _Product(name: "Mouse", type: "B", price: 12),
    _Product(name: "Mouse", type: "B", price: 12),
    _Product(name: "Mouse", type: "C", price: 10),
    _Product(name: "Laptop", type: "A", price: 100),
    _Product(name: "Laptop", type: "B", price: 120),
    _Product(name: "Laptop", type: "B", price: 120),
  ];

  {
    print("Hashcode >>>");
    products.forEach((element) {
      print(element.hashCode);
      // 257416280
      // 1045932166
      // 730517725
      // 586146378
      // 215518337
      // 471982393
      // 775971279
      // 335683510
      // 844714385
      // 633234047
      // 1021163746
    });
    print("<<< Hashcode \n");
  }

  {
    print(products.length); // 11
    print(products.toSet().length); // 11
    products.toSet().forEach((element) => print(element.toJson()));
    // { name: USB, type: A, price: 10}
    // { name: USB, type: B, price: 12}
    // { name: USB, type: C, price: 11}
    // { name: Mouse, type: A, price: 10}
    // { name: Mouse, type: B, price: 12}
    // { name: Mouse, type: C, price: 10}
    // { name: Laptop, type: A, price: 100}
    // { name: Laptop, type: B, price: 120}
  }

  {
    print("--- name ---");
    final result = products
        .whereWithIndex((element, index) => products.indexWhere((element2) => element2.name == element.name) == index)
        .toList();
    result.forEach((element) => print(element.toJson()));
    // { name: USB, type: A, price: 10}
    // { name: Mouse, type: A, price: 10}
    // { name: Laptop, type: A, price: 100}
  }

  {
    print("--- name and type---");
    final result = products
        .whereWithIndex((element, index) =>
            products.indexWhere((element2) => element2.name == element.name && element2.type == element.type) == index)
        .toList();
    result.forEach((element) => print(element.toJson()));
    // { name: USB, type: A, price: 10}
    // { name: USB, type: B, price: 12}
    // { name: USB, type: C, price: 11}
    // { name: Mouse, type: A, price: 10}
    // { name: Mouse, type: B, price: 12}
    // { name: Mouse, type: C, price: 10}
    // { name: Laptop, type: A, price: 100}
    // { name: Laptop, type: B, price: 120}
  }
}
