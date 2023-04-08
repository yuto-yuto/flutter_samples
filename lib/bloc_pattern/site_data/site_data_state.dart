import 'package:flutter/material.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data.dart';

enum SiteDataStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class SiteDataState {
  final SiteDataStatus status;
  final SiteData? siteData;

  const SiteDataState({this.status = SiteDataStatus.initial, this.siteData});

  SiteDataState copyWith({
    SiteDataStatus? status,
    SiteData? siteData,
  }) {
    return SiteDataState(
      status: status ?? this.status,
      siteData: siteData ?? this.siteData,
    );
  }
}
