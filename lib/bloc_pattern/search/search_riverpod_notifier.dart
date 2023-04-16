import 'package:flutter_samples/bloc_pattern/common.dart';
import 'package:flutter_samples/bloc_pattern/search/search_api.dart';
import 'package:flutter_samples/bloc_pattern/search/search_repository.dart';
import 'package:flutter_samples/bloc_pattern/search/search_result.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRiverpodNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;
  SearchResult? _cache;
  final _debouncer = Debouncer(duration: Duration(milliseconds: 500));

  SearchRiverpodNotifier(this._repository) : super(SearchStateEmpty());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      print("emptyr query");
      state = SearchStateEmpty();
      return;
    }

    print("query something");
    state = SearchStateInProgress(_cache);

    try {
      final searchResult = await _repository.searchData(query);
      _cache = searchResult;
      state = SearchStateCompleted(searchResult);
    } on SearchResultError catch (error) {
      state = SearchStateError(error.toString());
    }
  }

  void debouncedSearch(String query) {
    _debouncer.run(() {
      print("search starts");
      search(query);
    });
  }
}
