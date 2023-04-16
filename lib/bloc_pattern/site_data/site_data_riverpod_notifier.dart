import 'package:flutter_samples/bloc_pattern/site_data/site_data_repository.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Replacement of cubit in Bloc
class SiteDataRiverpodNotifier extends StateNotifier<SiteDataState> {
  final SiteDataRepository _repo;
  SiteDataRiverpodNotifier(this._repo) : super(SiteDataState(status: SiteDataStatus.initial));

  Future<void> read({required String filename, bool isFail = false}) async {
    state = SiteDataState(status: SiteDataStatus.loading);

    await Future.delayed(Duration(seconds: 1));
    if (isFail) {
      state = SiteDataState(status: SiteDataStatus.failure);
      return;
    }

    try {
      final result = await _repo.readSiteData(filename);
      state = SiteDataState(status: SiteDataStatus.success, siteData: result);
    } catch (e) {
      print(e);
      state = SiteDataState(status: SiteDataStatus.failure);
    }
  }
}
