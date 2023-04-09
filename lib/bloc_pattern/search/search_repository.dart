import 'package:flutter_samples/bloc_pattern/search/search_api.dart';
import 'package:flutter_samples/bloc_pattern/search/search_result.dart';

class SearchRepository {
  final SearchAPI _reader;
  int _count = 0;

  SearchRepository({
    required SearchAPI reader,
  }) : _reader = reader;

  Future<SearchResult> searchData(String query) async {
    _count++;
    if (_count % 3 != 0) {
      final siteDataJson = await _reader.fetch(query);
      return SearchResult.fromMap(siteDataJson);
    } else {
      await _reader.throwFetchError();
      throw Exception("Program can't be reached here.");
    }
  }
}
