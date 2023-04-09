import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/search/search_api.dart';
import 'package:flutter_samples/bloc_pattern/search/search_event.dart';
import 'package:flutter_samples/bloc_pattern/search/search_repository.dart';
import 'package:flutter_samples/bloc_pattern/search/search_result.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_samples/bloc_pattern/common.dart';

class SearchBloc extends Bloc<SearchQueryEvent, SearchState> {
  final SearchRepository _repository;
  SearchResult? _cache;

  SearchBloc(this._repository) : super(SearchStateEmpty()) {
    on<SearchQueryEvent>(
      _onTextChange,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onTextChange(SearchQueryEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      print("emptyr query");
      return emit(SearchStateEmpty());
    }

    print("query something");
    emit(SearchStateInProgress(_cache));

    try {
      final searchResult = await _repository.searchData(event.query);
      _cache = searchResult;
      emit(SearchStateCompleted(searchResult));
    } on SearchResultError catch (error) {
      emit(SearchStateError(error.toString()));
    }
  }

  @override
  void onChange(Change<SearchState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<SearchQueryEvent, SearchState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
