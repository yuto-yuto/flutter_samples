class SiteData {
  final int siteId;
  final String url;
  final String author;
  final String category;

  SiteData({
    required this.siteId,
    required this.url,
    required this.author,
    required this.category,
  });

  SiteData.empty()
      : siteId = -1,
        url = "",
        author = "",
        category = "";

  SiteData.fromJson(Map<String, dynamic> json)
      : siteId = json["id"],
        url = json["url"],
        author = json["author"],
        category = json["category"];

  @override
  String toString() {
    return "ID: $siteId\n" + "Author: $author\n" + "URL: $url\n" + "Category: $category";
  }
}
