import 'package:firebase_database/firebase_database.dart';

class FireImage {
  DateTime dateTime;
  int count;
  String url;

  FireImage(this.dateTime, this.count, this.url);

  toJson() {
    return {
      "count": count,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "url": url
    };
  }
}