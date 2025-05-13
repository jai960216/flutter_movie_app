import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey {
    return dotenv.env['TMDB_API_KEY'] ?? '';
  }

  static String get accessToken {
    return dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';
  }

  static String get baseUrl {
    return 'https://api.themoviedb.org/3';
  }

  static String get imageBaseUrl {
    return 'https://image.tmdb.org/t/p/w500';
  }

  static Map<String, String> get headers {
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
