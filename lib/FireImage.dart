class FireImage {
  String key;
  String name;
  DateTime dateTime;
  int count;
  String thumbnailUrl;
  String url;

  FireImage(this.name, this.dateTime, this.count, this.thumbnailUrl, this.url);

  toJson() {
    return {
      "name": name,
      "count": count,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "thumbnailUrl": thumbnailUrl,
      "url": url
    };
  }
}