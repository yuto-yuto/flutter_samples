import 'dart:math';

typedef SearchResultType = Map<String, dynamic>;

class SearchResultError implements Exception {
  final String message;
  SearchResultError({required this.message});

  @override
  String toString() {
    return "SearchResultError: $message";
  }
}

class SearchAPI {
  Future<SearchResultType> fetch(String query) async {
    await Future.delayed(Duration(seconds: 1));
    final id = Random().nextInt(100);
    final addedText = Random().nextInt(90000) + 10000;

    return {
      "id": id,
      "content": "${query}_$addedText",
    };
  }

  Future<SearchResultType> throwFetchError() async {
    await Future.delayed(Duration(seconds: 1));
    throw SearchResultError(message: "A faked error occurred!!");
  }
}
