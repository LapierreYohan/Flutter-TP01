

import 'package:flutter_application_1/models/gif.dart';

class Media {
  
  String? id;
  String? title;
  List<Gif>? gifs;
  double? created;
  String? contentDescription;
  String? url;
  String? itemUrl;
  List<String>? tags;
  List<String>? flags;
  bool? hasaudio;
  String? pos;

  Media({
    this.id,
    this.title,
    this.gifs,
    this.created,
    this.contentDescription,
    this.url,
    this.itemUrl,
    this.tags,
    this.flags,
    this.hasaudio,
    this.pos
  });
}