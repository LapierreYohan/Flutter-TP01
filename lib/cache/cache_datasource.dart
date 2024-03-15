class CacheDatasource {
  static final CacheDatasource _instance = CacheDatasource._internal();

  factory CacheDatasource() {
    return _instance;
  }

  CacheDatasource._internal();

  Map<String, dynamic> _cache = {};

  dynamic getValue(String key) {
    return _cache[key];
  }

  void setValue(String key, dynamic value) {
    _cache[key] = value;
  }

  void clearCache() {
    _cache.clear();
  }
}