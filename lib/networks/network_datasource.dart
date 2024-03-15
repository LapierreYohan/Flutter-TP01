
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/models/gif.dart';
import 'package:flutter_application_1/models/media.dart';
import 'package:flutter_application_1/networks/services/tenor_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkDatasource {

  static Future<List<String>> getTrendingTerms(String country, String locale) async {

    final apiUrl = TenorService.getTrendingTerms(country, locale);
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to get trending terms");
    } 

    final List<String> terms = [];
    final jsonData = json.decode(response.body);

    final resultsData = jsonData["results"];

    for (var term in resultsData) {
      terms.add(term);
    }

    return terms;
  }

  static Future<List<Media>> getSearch(String q, String contentFilter, String mediaFilter, String country, String locale, String limit, String pos, bool isCategory) async {

    String apiUrl; 

    if (isCategory) {
      apiUrl = TenorService.getCategoriesSearch(q, contentFilter, mediaFilter, country, locale, limit, pos);
    } else {
      apiUrl = TenorService.getSearch(q, contentFilter, mediaFilter, country, locale, limit, pos);
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to get search results");
    } 

    final List<Media> mediaList = [];
    final jsonData = json.decode(response.body);

    final resultsData = jsonData["results"];
    final nextPos = jsonData["next"];

    for (var media in resultsData) {
      final List<Gif> gifs = [];
      final gifData = media["media_formats"];

      gifData.forEach((formatName, formatData) {

        List<int>? dims = [];
        final dimsData = formatData["dims"];
        for (var dim in dimsData) {
          dims.add(dim);
        }

        double currentDuration = formatData["duration"].toDouble();

        Gif tmp = Gif(
          name: formatName,
          url: formatData["url"],
          duration: currentDuration,
          preview: formatData["preview"],
          dims: dims,
          size: formatData["size"]
        );

        gifs.add(tmp);
      });

      final tagsData = media["tags"];
      final flagsData = media["flags"];

      List<String> tags = [];
      List<String> flags = [];

      for (var tag in tagsData) {
        tags.add(tag);
      }

      for (var flag in flagsData) {
        flags.add(flag);
      }

      Media tmpMedia = Media(
        id: media["id"],
        title: media["title"],
        gifs: gifs,
        created: media["created"],
        contentDescription: media["content_description"],
        url: media["url"],
        itemUrl: media["itemurl"],
        tags: tags,
        flags: flags,
        hasaudio: media["hasaudio"],
        pos: nextPos
      );

      mediaList.add(tmpMedia);
    }

    return mediaList;
  }

  static Future<List<Category>> getCategories() async {

    final apiUrl = TenorService.getCategories();
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to get categories");
    } 

    final List<Category> categories = [];
    final jsonData = json.decode(response.body);

    final resultsData = jsonData["tags"];

    for (var category in resultsData) {
      Category tmp = Category(
        name: category["searchterm"],
        url: category["image"],
        path: category["path"],
        hashtag: category["name"]
      );

      categories.add(tmp);
    }

    return categories;
  }

}