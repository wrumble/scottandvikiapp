import 'dart:io';

class UploadImage {
  File file;
  DateTime dateTime;
  int count;

  UploadImage(this.file, this.dateTime, this.count);

  String getName() {
    final date = this.dateTime;
    return "${this.count}+$date.jpg";
  }
}