class FireImage {
  String key;
  String name;
  DateTime dateTime;
  int count;
  String url;

  FireImage(this.name, this.dateTime, this.count, this.url);

  toJson() {
    return {
      "name": name,
      "count": count,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "url": url
    };
  }
}