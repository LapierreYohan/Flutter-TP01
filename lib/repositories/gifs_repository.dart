

import 'package:flutter_application_1/cache/cache_datasource.dart';
import 'package:flutter_application_1/entities/detail.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/models/media.dart';
import 'package:flutter_application_1/networks/network_datasource.dart';

class GifsRepository {

  final CacheDatasource _cache = CacheDatasource();

  Future<List<String>> fetchTrends() async {

    List<String>? cachedTerms = _cache.getValue('trends');
    if (cachedTerms != null) {
      return cachedTerms;
    }

    List<String> terms = await NetworkDatasource.getTrendingTerms("EN", "en_EN");
    _cache.setValue("trends", terms);

    return terms;
  }

  Future<List<Detail>> fetchSearch(String q, bool isCategory) async {

    String? pos = _cache.getValue('search_pos') as String? ?? "0";
    
    List<Media> mediaList = await NetworkDatasource.getSearch(q, "high", "minimal", "EN", "en_EN", "30", pos, isCategory);
    // Update the position for the next search
    _cache.setValue("search_pos", mediaList[0].pos);

    List<Detail> details = [];

    for (var media in mediaList) {

      String url = "";

      if (media.gifs == null) {
        break;
      }

      for (var gif in media.gifs!) {
        if (gif.name == "gif") {
          url = gif.url!;
        }
      }

      if (url.isEmpty) {
        break;
      }
      
      Detail detail = Detail(
        description: media.contentDescription,
        url: url,
      );

      details.add(detail);
    }

    return details;
  }

  void clearCacheValue(String key) {
    _cache.setValue(key, null);
  }

  Future<List<Detail>> fetchCategory() async {
    List<Category> categories = await NetworkDatasource.getCategories();

    List<Detail> details = [];
    for (var category in categories) {
      Detail detail = Detail(
        description: category.name,
        url: category.url!,
      );
      details.add(detail);
    }

    return details;
  }
}