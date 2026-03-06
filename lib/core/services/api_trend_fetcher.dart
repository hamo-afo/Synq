import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/trend_model.dart';
import 'youtube_api_service.dart';
import 'stock_api_service.dart';
import 'political_news_api_service.dart';

/// Enhanced TrendRepository that fetches from external APIs and writes to Firestore.
/// This service acts as a bridge between external data sources and the local cache.
class ApiTrendFetcher {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch YouTube trends from API and save to Firestore
  Future<List<TrendModel>> fetchAndSaveYoutubeTrends() async {
    try {
      // Fetch from YouTube API with timeout
      final videos =
          await YouTubeApiService.fetchTrendingVideos(maxResults: 15).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw Exception('YouTube API request timed out'),
      );

      // Transform to TrendModel and save to Firestore
      final trends = <TrendModel>[];

      for (final video in videos) {
        final trend = TrendModel(
          id: video['videoId'] ?? '',
          title: video['title'] ?? 'Untitled',
          category: 'youtube',
          summary:
              '${video['channelTitle'] ?? 'Unknown'} - ${video["viewCount"] ?? 0} views',
          content: video['description'] ?? 'No description available',
          date: DateTime.parse(
              video['publishedAt'] ?? DateTime.now().toIso8601String()),
          source: 'YouTube',
          fetchedAt: DateTime.now(),
          extras: {
            'videoId': video['videoId'],
            'channelTitle': video['channelTitle'],
            'viewCount': video['viewCount'],
            'likeCount': video['likeCount'],
            'commentCount': video['commentCount'],
            'thumbnailUrl': video['thumbnailUrl'],
            // Provide canonical image and playable URL for UI
            'imageUrl': video['thumbnailUrl'],
            'videoUrl': video['videoId'] != null
                ? 'https://www.youtube.com/watch?v=${video['videoId']}'
                : null,
          },
        );

        // Save to Firestore but DO NOT overwrite engagement fields (likes/comments)
        final mapToSave = Map<String, dynamic>.from(trend.toMap());
        mapToSave.remove('likes');
        mapToSave.remove('likedBy');
        mapToSave.remove('comments');

        await _db
            .collection('trends')
            .doc('youtube_${video['videoId']}')
            .set(mapToSave, SetOptions(merge: true))
            .catchError((e) {
          // ignore: avoid_print
          print('Error saving YouTube trend to Firestore: $e');
        });

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Saved ${trends.length} YouTube trends to Firestore');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('ApiTrendFetcher.fetchAndSaveYoutubeTrends error: $e');
      rethrow;
    }
  }

  /// Fetch stock trends from API and save to Firestore
  /// Fetch stock trends from API and save to Firestore
  Future<List<TrendModel>> fetchAndSaveStockTrends() async {
    try {
      // Fetch from Stock API with timeout
      final stocks = await StockApiService.fetchTopGainers().timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw Exception('Stock API request timed out'),
      );

      // Transform to TrendModel and save to Firestore
      final trends = <TrendModel>[];

      for (final stock in stocks) {
        final changePercent = stock['changePercentage'] ?? '0%';
        final symbol = stock['symbol'] ?? 'UNKNOWN';
        // Always start with a guaranteed inline SVG placeholder
        final bg = '4B7F6A'; // greenish-grey
        final fg = 'FFFFFF';
        String imageUrl =
            'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="600" height="300"><rect fill="%23$bg" width="600" height="300"/><text x="50%" y="50%" font-size="48" font-weight="bold" fill="%23$fg" text-anchor="middle" dominant-baseline="middle">$symbol</text></svg>';

        try {
          final series = await StockApiService.getIntradayTimeSeries(symbol,
              interval: '60min');
          if (series.isNotEmpty) {
            // extract close prices (most recent entries last)
            final closes = series
                .map((e) => double.tryParse(e['close'].toString()) ?? 0.0)
                .toList();
            // keep up to 30 points, use last values
            final points = closes.length > 30 ? closes.sublist(0, 30) : closes;
            if (points.isNotEmpty) {
              // build QuickChart line chart config
              final chartConfig = {
                'type': 'line',
                'data': {
                  'labels': List.generate(points.length, (i) => ''),
                  'datasets': [
                    {
                      'data': points,
                      'borderColor': '#10B981',
                      'backgroundColor': 'transparent',
                      'fill': false,
                      'pointRadius': 0,
                    }
                  ]
                },
                'options': {
                  'plugins': {
                    'legend': {'display': false}
                  },
                  'scales': {
                    'x': {'display': false},
                    'y': {'display': false}
                  },
                  'elements': {
                    'line': {'tension': 0.3}
                  }
                }
              };
              final encoded = Uri.encodeComponent(jsonEncode(chartConfig));
              final quickChartUrl =
                  'https://quickchart.io/chart?c=$encoded&w=600&h=300&backgroundColor=transparent';
              imageUrl = quickChartUrl;
              // ignore: avoid_print
              print('Generated QuickChart for $symbol: $quickChartUrl');
            }
          }
        } catch (e) {
          // ignore and fallback to placeholder with ticker
          // ignore: avoid_print
          print(
              'Could not build chart for $symbol: $e. Using placeholder instead.');
        }

        // ignore: avoid_print
        print('Stock $symbol image URL: $imageUrl');

        final trend = TrendModel(
          id: symbol,
          title: '$symbol - ${stock['changePercentage']}',
          category: 'stock',
          summary:
              'Price: ${stock['price']}, Change: ${stock['changeAmount']} (${stock['changePercentage']})',
          content:
              'Stock Symbol: $symbol\nPrice: ${stock['price']}\nChange: ${stock['changeAmount']}\nPercentage: ${stock['changePercentage']}\nVolume: ${stock['volume']}',
          date: DateTime.now(),
          source: 'Alpha Vantage',
          fetchedAt: DateTime.now(),
          extras: {
            'symbol': symbol,
            'price': stock['price'],
            'changeAmount': stock['changeAmount'],
            'changePercentage': changePercent,
            'volume': stock['volume'],
            'isGainer': changePercent.contains('-') ? false : true,
            // use generated chart/placeholder image (also set as thumbnail for better UI fallbacks)
            'imageUrl': imageUrl,
            'thumbnailUrl': imageUrl,
          },
        );

        // Save to Firestore but avoid overwriting engagement fields
        final stockMap = Map<String, dynamic>.from(trend.toMap());
        stockMap.remove('likes');
        stockMap.remove('likedBy');
        stockMap.remove('comments');

        await _db
            .collection('trends')
            .doc('stock_$symbol')
            .set(stockMap, SetOptions(merge: true))
            .catchError((e) {
          // ignore: avoid_print
          print('Error saving stock trend to Firestore: $e');
        });

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Saved ${trends.length} stock trends to Firestore');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('ApiTrendFetcher.fetchAndSaveStockTrends error: $e');
      rethrow;
    }
  }

  /// Fetch political news from API and save to Firestore
  /// Fetch political trends from API and save to Firestore
  Future<List<TrendModel>> fetchAndSavePoliticalTrends() async {
    try {
      // Fetch from Political News API with timeout
      final articles =
          await PoliticalNewsApiService.fetchPoliticalNews(pageSize: 15)
              .timeout(
        const Duration(seconds: 20),
        onTimeout: () =>
            throw Exception('Political News API request timed out'),
      );

      // Transform to TrendModel and save to Firestore
      final trends = <TrendModel>[];

      for (int i = 0; i < articles.length; i++) {
        final article = articles[i];
        final trend = TrendModel(
          id: 'political_${article['url']?.hashCode ?? i}',
          title: article['title'] ?? 'No Title',
          category: 'political',
          summary:
              '${article['source']} - ${article['author'] != 'Unknown' ? 'by ${article['author']}' : ''}',
          content: article['content'] ??
              article['description'] ??
              'No content available',
          date: DateTime.parse(
              article['publishedAt'] ?? DateTime.now().toIso8601String()),
          source: article['source'] ?? 'News',
          fetchedAt: DateTime.now(),
          extras: {
            'url': article['url'],
            'imageUrl': article['imageUrl'],
            'author': article['author'],
            'source': article['source'],
            'description': article['description'],
          },
        );

        // Save to Firestore but avoid overwriting likes/comments
        final polMap = Map<String, dynamic>.from(trend.toMap());
        polMap.remove('likes');
        polMap.remove('likedBy');
        polMap.remove('comments');

        // Save using deterministic id to avoid creating duplicate documents
        await _db
            .collection('trends')
            .doc(trend.id)
            .set(polMap, SetOptions(merge: true))
            .catchError((e) {
          // ignore: avoid_print
          print('Error saving political trend to Firestore: $e');
        });

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Saved ${trends.length} political trends to Firestore');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('ApiTrendFetcher.fetchAndSavePoliticalTrends error: $e');
      rethrow;
    }
  }

  /// Fetch all trends from all APIs and save to Firestore
  Future<void> fetchAndSaveAllTrends() async {
    try {
      await Future.wait([
        fetchAndSaveYoutubeTrends(),
        fetchAndSaveStockTrends(),
        fetchAndSavePoliticalTrends(),
      ]);
      // ignore: avoid_print
      print('Successfully fetched and saved all trends');
    } catch (e) {
      // ignore: avoid_print
      print('ApiTrendFetcher.fetchAndSaveAllTrends error: $e');
      rethrow;
    }
  }
}
