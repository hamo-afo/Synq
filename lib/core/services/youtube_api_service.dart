import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_keys.dart';

/// Service for fetching trending YouTube videos using the YouTube Data API.
///
/// Provides methods to retrieve trending videos by region, search terms, or video IDs.
/// Handles API calls to YouTube's v3 API, parses responses, and returns structured
/// video data including titles, descriptions, statistics, and thumbnails.
class YouTubeApiService {
  // Using YouTube Data API v3
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3/videos';
  static final String _apiKey = ApiKeys.youtubeApiKey;

  /// Fetch trending videos for a given region
  /// Returns a list of video data (title, description, view count, etc.)
  static Future<List<Map<String, dynamic>>> fetchTrendingVideos({
    String regionCode = 'US',
    int maxResults = 20,
  }) async {
    try {
      final params = {
        'part': 'snippet,statistics',
        'chart': 'mostPopular',
        'regionCode': regionCode,
        'maxResults': maxResults.toString(),
        'key': _apiKey,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('YouTube API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((item) {
          final snippet = item['snippet'] ?? {};
          final stats = item['statistics'] ?? {};

          return {
            'videoId': item['id'] ?? '',
            'title': snippet['title'] ?? 'Unknown Title',
            'description': snippet['description'] ?? '',
            'channelTitle': snippet['channelTitle'] ?? 'Unknown Channel',
            'publishedAt':
                snippet['publishedAt'] ?? DateTime.now().toIso8601String(),
            'thumbnailUrl': snippet['thumbnails']?['medium']?['url'] ?? '',
            'viewCount': stats['viewCount'] ?? '0',
            'likeCount': stats['likeCount'] ?? '0',
            'commentCount': stats['commentCount'] ?? '0',
          };
        }).toList();
      } else if (response.statusCode == 403) {
        throw Exception(
            'YouTube API key invalid or quota exceeded. Response: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch YouTube trends: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('YouTubeApiService.fetchTrendingVideos error: $e');
      rethrow;
    }
  }

  /// Fetch videos by search query (alternative to trending)
  static Future<List<Map<String, dynamic>>> searchVideos({
    required String query,
    int maxResults = 20,
  }) async {
    try {
      final params = {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': maxResults.toString(),
        'order': 'viewCount',
        'key': _apiKey,
      };

      final uri = Uri.parse('https://www.googleapis.com/youtube/v3/search')
          .replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('YouTube API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((item) {
          final snippet = item['snippet'] ?? {};
          return {
            'videoId': item['id']?['videoId'] ?? '',
            'title': snippet['title'] ?? 'Unknown Title',
            'description': snippet['description'] ?? '',
            'channelTitle': snippet['channelTitle'] ?? 'Unknown Channel',
            'publishedAt':
                snippet['publishedAt'] ?? DateTime.now().toIso8601String(),
            'thumbnailUrl': snippet['thumbnails']?['medium']?['url'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to search videos: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('YouTubeApiService.searchVideos error: $e');
      rethrow;
    }
  }
}
