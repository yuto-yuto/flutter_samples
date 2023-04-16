import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/bloc_pattern/common.dart';
import 'package:flutter_samples/bloc_pattern/search/search_api.dart';
import 'package:flutter_samples/bloc_pattern/search/search_event.dart';
import 'package:flutter_samples/bloc_pattern/search/search_repository.dart';
import 'package:flutter_samples/bloc_pattern/search/search_riverpod_notifier.dart';
import 'package:flutter_samples/bloc_pattern/search/search_state.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_reader.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_repository.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_riverpod_notifier.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';

// ------------------------------
// Provider
// ------------------------------
final siteDataRepositoryProvider = Provider<SiteDataRepository>((ref) {
  final reader = SiteDataReader();
  return SiteDataRepository(reader: reader);
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final reader = SearchAPI();
  return SearchRepository(reader: reader);
});

// ------------------------------
// StateNotifierProvider
// ------------------------------
final tfSiteDataStateNotifierProvider = StateNotifierProvider<SiteDataRiverpodNotifier, SiteDataState>((ref) {
  final repository = ref.read(siteDataRepositoryProvider);
  return SiteDataRiverpodNotifier(repository);
});

final unknownSiteDataStateNotifierProvider = StateNotifierProvider<SiteDataRiverpodNotifier, SiteDataState>((ref) {
  final repository = ref.read(siteDataRepositoryProvider);
  return SiteDataRiverpodNotifier(repository);
});

typedef SearchProvider = StateNotifierProvider<SearchRiverpodNotifier, SearchState>;
final searchProvider1 = StateNotifierProvider<SearchRiverpodNotifier, SearchState>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchRiverpodNotifier(repository);
});
final searchProvider2 = StateNotifierProvider<SearchRiverpodNotifier, SearchState>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchRiverpodNotifier(repository);
});
final searchProvider3 = StateNotifierProvider<SearchRiverpodNotifier, SearchState>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchRiverpodNotifier(repository);
});

final queryControllerProvider = Provider<TextEditingController>((ref) {
  final searchApi = ref.read(searchProvider3.notifier);
  final controller = TextEditingController();
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  String lastValue = "";
  controller.addListener(() async {
    if (lastValue == controller.text) {
      return;
    }
    lastValue = controller.text;
    debouncer.run(() => searchApi.search(controller.text));
  });

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

// final queryResultProvider = StateNotifierProvider.autoDispose<SearchRiverpodNotifier, SearchState>((ref) {
//   final searchApi = ref.read(queryTextController);

//   controller.addListener(() async {
//     await ref.debounce(Duration(milliseconds: 500));
//     searchApi.search(controller.text);
//   });
//   final repository = ref.read(searchRepositoryProvider);
//   return SearchRiverpodNotifier(repository);
// });
