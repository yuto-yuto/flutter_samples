import 'dart:convert';
import 'dart:io';

class SiteDataReader {
  Future<Map<String, dynamic>> readSiteData(String filepath) async {
    final file = File(filepath);
    final data = await file.readAsString();
    return json.decode(data);
  }
}
