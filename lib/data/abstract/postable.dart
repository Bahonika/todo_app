import 'dart:io';

abstract class Postable {
  Map<String, dynamic> toJson();
}

abstract class PostableWithMultipart extends Postable {
  Map<String, File> getFiles();
}

