import 'package:flutter_samples/bloc_pattern/search/search_api.dart';

class SearchResult {
  final int id;
  final String content;
  SearchResult({
    required this.id,
    required this.content,
  });

  SearchResult.fromMap(SearchResultType dataMap)
      : id = dataMap["id"],
        content = dataMap["content"];

  @override
  String toString() {
    return "id: $id\ncontent: $content";
  }
}
