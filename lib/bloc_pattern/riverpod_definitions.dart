import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_reader.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_repository.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_riverpod_notifier.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';

// Provider
final siteDataRepositoryProvider = Provider<SiteDataRepository>((ref) {
  final reader = SiteDataReader();
  return SiteDataRepository(reader: reader);
});

// StateProvider
final tfSiteDataStateNotifierProvider = StateNotifierProvider<SiteDataRiverpodNotifier,SiteDataState>((ref) {
  final repository = ref.read(siteDataRepositoryProvider);
  return SiteDataRiverpodNotifier(repository);
});

final unknownSiteDataStateNotifierProvider = StateNotifierProvider<SiteDataRiverpodNotifier,SiteDataState>((ref) {
  final repository = ref.read(siteDataRepositoryProvider);
  return SiteDataRiverpodNotifier(repository);
});
  
// final unknownStateProvider = StateProvider<SiteDataState>((ref) => SiteDataState());


// final tfSiteDataProvider = Provider<SiteData>((ref) {
//   ref.read
//   return;
// });
