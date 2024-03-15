const apiKey = String.fromEnvironment("API_KEY");
const baseUrl = "https://tenor.googleapis.com/v2";  

class TenorService {
  
  static String getTrendingTerms(String country, String locale) {
    return "$baseUrl/trending_terms?key=$apiKey&country=$country&locale=$locale";  
  }

  static String getSearch(String q, String contentFilter, String mediaFilter, String country, String locale, String limit, String pos) {
    return "$baseUrl/search?q=$q&key=$apiKey&country=$country&locale=$locale&contentfilter=$contentFilter&media_filter=$mediaFilter&limit=$limit&pos=$pos";  
  }

  static String getCategories() {
    return "$baseUrl/categories?key=$apiKey";  
  }

  static String getCategoriesSearch(String q, String contentFilter, String mediaFilter, String country, String locale, String limit, String pos) {
    return "$baseUrl/search?q=$q&key=$apiKey&component=categories&country=$country&locale=$locale&contentfilter=$contentFilter&media_filter=$mediaFilter&limit=$limit&pos=$pos";  
  }
}