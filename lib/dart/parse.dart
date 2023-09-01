void main() {
  String str1 = "123";
  String str2 = "FC";
  String str3 = "hogeZ";

  disp(() => int.parse(str1)); // 123
  // FormatException: Invalid radix-10 number (at character 1)
  disp(() => int.parse(str2));

  disp(() => int.parse(str2, radix: 16)); // 252

  // FormatException: Invalid radix-10 number (at character 1)
  disp(() => int.parse(str3));
  disp(() => int.parse(str3, radix: 36)); // 29694491

  // print(int.parse("hoge", onError: (_) => 0)); // 0
  print(int.tryParse("hoge") ?? 0);
  
}

void disp(int Function() cb) {
  try {
    final result = cb();
    print(result);
  } catch (e) {
    print(e);
  }
}
