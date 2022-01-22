import 'dart:convert';

class _Nested {
  final String hoge;
  final String foo;
  _Nested(this.hoge, this.foo);
  _Nested.fromJson(Map<String, dynamic> json)
      : hoge = json["hoge"],
        foo = json["foo"];
}

class _Person {
  final String name;
  final int age;
  final String job;
  final _Nested nested;

  _Person(this.name, this.age, this.job, this.nested);
  _Person.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        age = json["age"],
        job = json["job"],
        nested = _Nested.fromJson(json["nested"]);
}

void main() {
  final json = '''{
  "name": "Yuto",
  "age": 34,
  "job": "Software Engineer",
  "nested": {
    "hoge": "hoge-vallue",
    "foo": "foo-vallue"
  }
}''';
  print(json);

  print("-------------");

  {
    final decoded = jsonDecode(json);
    print(decoded);
// NoSuchMethodError: Class '_InternalLinkedHashMap<String, dynamic>' has no instance getter 'name'.
// print(decoded.name);
    print(decoded["name"]);
    print(decoded["age"]);
    print(decoded["age"] is int);
  }

  print("-------------");
  {
    Map<String, dynamic> decoded = jsonDecode(json);
    print(decoded);
    // NoSuchMethodError: Class '_InternalLinkedHashMap<String, dynamic>' has no instance getter 'name'.
    // print(decoded.name);
    print(decoded.entries);
  }

  print("==================");
  {
    final person = _Person.fromJson(jsonDecode(json));
    print("name: ${person.name}, age: ${person.age}, job: ${person.job}");
  } 

  print("==================");
  {
    final decoded = jsonDecode(json);
    print(decoded["nested"]["hoge"]); // hoge-vallue
    print(decoded["nested"]["foo"]);  // foo-vallue
  }
  
  print("==================");
  {
    final person = _Person.fromJson(jsonDecode(json));
    print("name: ${person.name}, age: ${person.age}, job: ${person.job}");
    print("nested: { hoge: ${person.nested.hoge}, foo: ${person.nested.foo} }");
  }
}
