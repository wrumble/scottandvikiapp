class FireImage {
  String key;
  String name;
  DateTime dateTime;
  int count;
  String thumbnailUrl;
  String url;
  bool isAnImage;

  FireImage(this.name, this.dateTime, this.count, this.thumbnailUrl, this.url, [this.isAnImage = true]);

  toJson() {
    return {
      "name": name,
      "count": count,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "thumbnailUrl": thumbnailUrl,
      "url": url,
      "isAnImage": isAnImage
    };
  }
}