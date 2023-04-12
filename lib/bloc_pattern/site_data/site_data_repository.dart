import 'package:path/path.dart' as p;
import 'package:flutter_samples/bloc_pattern/site_data/site_data.dart';
import 'package:flutter_samples/bloc_pattern/site_data/site_data_reader.dart';

class SiteDataRepository {
  final SiteDataReader _reader;
  SiteDataRepository({required SiteDataReader reader}) : _reader = reader;

  Future<SiteData> readSiteData(String filename) async {
    final filepath = p.join("lib/resources", filename);
    final siteDataJson = await _reader.readSiteData(filepath);
    return SiteData.fromJson(siteDataJson);
  }
}
