import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_keys.dart';

class PoliticalNewsApiService {
  // Using NewsAPI for political news
  static const String _newsApiUrl = 'https://newsapi.org/v2/everything';
  static final String _newsApiKey = ApiKeys.newsApiKey;

  /// Fetch political news using NewsAPI
  /// Returns list of news articles (title, description, source, url, image, etc.)
  static Future<List<Map<String, dynamic>>> fetchPoliticalNews({
    String country = 'us',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final params = {
        'q': 'politics OR political OR government OR election',
        'sortBy': 'publishedAt',
        'language': 'en',
        'pageSize': pageSize.toString(),
        'page': page.toString(),
        'apiKey': _newsApiKey,
      };

      final uri = Uri.parse(_newsApiUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('News API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>? ?? [];

        return articles.map((article) {
          return {
            'source': article['source']?['name'] ?? 'Unknown',
            'title': article['title'] ?? 'No Title',
            'description': article['description'] ?? '',
            'content': article['content'] ?? '',
            'url': article['url'] ?? '',
            'imageUrl': article['urlToImage'] ?? '',
            'publishedAt':
                article['publishedAt'] ?? DateTime.now().toIso8601String(),
            'author': article['author'] ?? 'Unknown',
          };
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid NewsAPI key');
      } else if (response.statusCode == 429) {
        throw Exception('NewsAPI rate limit exceeded');
      } else {
        throw Exception(
            'Failed to fetch political news: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('PoliticalNewsApiService.fetchPoliticalNews error: $e');
      rethrow;
    }
  }

  /// Fetch news by specific political topic
  static Future<List<Map<String, dynamic>>> fetchNewsByTopic(
    String topic, {
    int pageSize = 20,
  }) async {
    try {
      final params = {
        'q': topic,
        'sortBy': 'publishedAt',
        'language': 'en',
        'pageSize': pageSize.toString(),
        'apiKey': _newsApiKey,
      };

      final uri = Uri.parse(_newsApiUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('News API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>? ?? [];

        return articles.map((article) {
          return {
            'source': article['source']?['name'] ?? 'Unknown',
            'title': article['title'] ?? 'No Title',
            'description': article['description'] ?? '',
            'content': article['content'] ?? '',
            'url': article['url'] ?? '',
            'imageUrl': article['urlToImage'] ?? '',
            'publishedAt':
                article['publishedAt'] ?? DateTime.now().toIso8601String(),
            'author': article['author'] ?? 'Unknown',
          };
        }).toList();
      } else {
        throw Exception(
            'Failed to fetch news by topic: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('PoliticalNewsApiService.fetchNewsByTopic error: $e');
      rethrow;
    }
  }

  /// Fetch top headlines for a country
  static Future<List<Map<String, dynamic>>> fetchTopHeadlines({
    String country = 'us',
    String? category = 'general',
    int pageSize = 20,
  }) async {
    try {
      final params = {
        'country': country,
        if (category != null) 'category': category,
        'pageSize': pageSize.toString(),
        'apiKey': _newsApiKey,
      };

      final uri = Uri.parse('https://newsapi.org/v2/top-headlines')
          .replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('News API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>? ?? [];

        return articles.map((article) {
          return {
            'source': article['source']?['name'] ?? 'Unknown',
            'title': article['title'] ?? 'No Title',
            'description': article['description'] ?? '',
            'content': article['content'] ?? '',
            'url': article['url'] ?? '',
            'imageUrl': article['urlToImage'] ?? '',
            'publishedAt':
                article['publishedAt'] ?? DateTime.now().toIso8601String(),
            'author': article['author'] ?? 'Unknown',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch headlines: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('PoliticalNewsApiService.fetchTopHeadlines error: $e');
      rethrow;
    }
  }
}
