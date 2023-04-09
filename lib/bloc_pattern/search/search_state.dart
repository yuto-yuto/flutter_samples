import 'package:flutter_samples/bloc_pattern/search/search_result.dart';

abstract class SearchState {}

class SearchStateEmpty extends SearchState {}

class SearchStateInProgress extends SearchState {
  final SearchResult? cache;
  SearchStateInProgress([this.cache]);
}

class SearchStateCompleted extends SearchState {
  final SearchResult data;
  SearchStateCompleted(this.data) : super();
}

class SearchStateError extends SearchState {
  final String error;
  SearchStateError(this.error) : super();
}
