import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_samples/bloc_pattern/site_data_repository.dart';
import 'package:flutter_samples/bloc_pattern/site_data_state.dart';

abstract class SiteDataCubit extends Cubit<SiteDataState> {
  final SiteDataRepository _repo;
  final String filename;
  SiteDataCubit(this._repo, {required this.filename}) : super(SiteDataState(status: SiteDataStatus.initial));

  void read({bool isFail = false}) async {
    emit(SiteDataState(status: SiteDataStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    if (isFail) {
      emit(SiteDataState(status: SiteDataStatus.failure));
      return;
    }

    final result = await _repo.readSiteData(filename);
    emit(SiteDataState(status: SiteDataStatus.success, siteData: result));
  }
}

class TechnicalFeederCubit extends SiteDataCubit {
  TechnicalFeederCubit(SiteDataRepository repo, {required String filename}) : super(repo, filename: filename);
}

class UnknownSiteCubit extends SiteDataCubit {
  UnknownSiteCubit(SiteDataRepository repo, {required String filename}) : super(repo, filename: filename);
}
