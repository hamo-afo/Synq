import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/trend_model.dart';

/// Mock data generator for testing without real API keys.
/// Generates realistic sample data and writes directly to Firestore.
class MockTrendDataGenerator {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const List<String> youtubeVideoTitles = [
    'Top 10 Python Tips for 2025',
    'Flutter Performance Optimization Guide',
    'Web Development Trends 2025',
    'AI and Machine Learning Breakthrough',
    'Building Scalable APIs',
    'The Future of Cloud Computing',
    'Mobile App Security Best Practices',
    'React 19 Deep Dive',
    'Database Design Patterns',
    'DevOps Automation Tutorial',
  ];

  static const List<String> youtubeVideoIds = [
    'dQw4w9WgXcQ', // Rick Roll
    'jNQXAC9IVRw', // First YouTube video
    'RgKAFK5djSk', // YouTube Rewind
    '37pnRvH2pAA', // Charlie Bit My Finger
    'cE0wfjsybIQ', // David After Dentist
    'DLzxrzFCyOs', // Greatest Freak Out
    '3oOt-wN5YMI', // Numa Numa
    'X19bnGAz0fM', // Kermit the Frog
    '9bZkp7q19f0', // Gangnam Style
    'dQw4w9WgXcQ', // Rick Roll (duplicate for 10)
  ];

  static const List<String> youtubeChannels = [
    'Tech Daily',
    'Code Masters',
    'Dev Tips',
    'Programming Hub',
    'Coding Academy',
  ];

  static const List<String> youtubeDescriptions = [
    'Learn the best practices and tips for modern development',
    'A comprehensive guide to building better applications',
    'Master the fundamentals of software engineering',
    'Deep dive into advanced concepts',
    'Practical examples and real-world applications',
  ];

  static const List<String> stockSymbols = [
    'AAPL',
    'GOOGL',
    'MSFT',
    'AMZN',
    'TSLA',
    'META',
    'NVDA',
    'NFLX',
    'IBM',
    'INTEL'
  ];

  static const List<String> politicalTopics = [
    'New Economic Policy Announced',
    'Trade Negotiations Underway',
    'Climate Summit Reaches Agreement',
    'Infrastructure Bill Passed',
    'Tax Reform Proposal Debated',
    'Healthcare Reform Discussions',
    'Education Funding Increase',
    'Defense Spending Review',
    'Immigration Policy Update',
    'Energy Independence Initiative',
  ];

  static const List<String> newsSourcesPolicy = [
    'Reuters',
    'AP News',
    'BBC News',
    'The Guardian',
    'NPR',
  ];

  /// Generate and save mock YouTube trends
  Future<List<TrendModel>> generateMockYoutubeTrends() async {
    try {
      final trends = <TrendModel>[];
      final now = DateTime.now();

      for (int i = 0; i < youtubeVideoTitles.length; i++) {
        final title = youtubeVideoTitles[i];
        final channel = youtubeChannels[i % youtubeChannels.length];
        final videoId = youtubeVideoIds[i];
        final views = (100000 + (i * 50000)).toString();
        final likes = (5000 + (i * 1000)).toString();

        final trend = TrendModel(
          id: 'youtube_mock_$i',
          title: title,
          category: 'youtube',
          summary: '$channel • $views views',
          content: youtubeDescriptions[i % youtubeDescriptions.length],
          date: now.subtract(Duration(hours: i)),
          source: 'YouTube',
          fetchedAt: now,
          extras: {
            'videoId': videoId,
            'channelTitle': channel,
            'viewCount': views,
            'likeCount': likes,
            'commentCount': (500 + (i * 100)).toString(),
            'thumbnailUrl': 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
          },
        );

        // Save to Firestore but do not overwrite engagement fields
        final ytMap = Map<String, dynamic>.from(trend.toMap());
        ytMap.remove('likes');
        ytMap.remove('likedBy');
        ytMap.remove('comments');
        await _db
            .collection('trends')
            .doc('youtube_mock_$i')
            .set(ytMap, SetOptions(merge: true));

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Generated ${trends.length} mock YouTube trends');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('MockTrendDataGenerator.generateMockYoutubeTrends error: $e');
      rethrow;
    }
  }

  /// Generate and save mock stock trends
  Future<List<TrendModel>> generateMockStockTrends() async {
    try {
      final trends = <TrendModel>[];
      final now = DateTime.now();

      for (int i = 0; i < stockSymbols.length; i++) {
        final symbol = stockSymbols[i];
        final price = (100.0 + (i * 25.5)).toStringAsFixed(2);
        final changePercent = ((i % 2 == 0 ? 1 : -1) * (2.5 + (i * 0.5)))
            .toStringAsFixed(2); // Mix of gains and losses
        final changeAmount =
            ((double.parse(price) * double.parse(changePercent)) / 100)
                .toStringAsFixed(2);
        final volume = (1000000 + (i * 500000)).toString();
        final isGainer = !changePercent.contains('-');

        final trend = TrendModel(
          id: 'stock_mock_$symbol',
          title: '$symbol - ${changePercent}%',
          category: 'stock',
          summary: 'Price: \$$price, Change: $changeAmount ($changePercent%)',
          content:
              'Stock: $symbol\nPrice: \$$price\nChange: $changeAmount\nChange %: $changePercent%\nVolume: $volume',
          date: now.subtract(Duration(minutes: i * 15)),
          source: 'Market Data',
          fetchedAt: now,
          extras: {
            'symbol': symbol,
            'price': price,
            'changeAmount': changeAmount,
            'changePercentage': changePercent,
            'volume': volume,
            'isGainer': isGainer,
            'imageUrl':
                'https://via.placeholder.com/300x200/1e40af/ffffff?text=$symbol',
          },
        );

        // Save to Firestore but do not overwrite engagement fields
        final stMap = Map<String, dynamic>.from(trend.toMap());
        stMap.remove('likes');
        stMap.remove('likedBy');
        stMap.remove('comments');
        await _db
            .collection('trends')
            .doc('stock_mock_$symbol')
            .set(stMap, SetOptions(merge: true));

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Generated ${trends.length} mock stock trends');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('MockTrendDataGenerator.generateMockStockTrends error: $e');
      rethrow;
    }
  }

  /// Generate and save mock political news trends
  Future<List<TrendModel>> generateMockPoliticalTrends() async {
    try {
      final trends = <TrendModel>[];
      final now = DateTime.now();

      for (int i = 0; i < politicalTopics.length; i++) {
        final title = politicalTopics[i];
        final source = newsSourcesPolicy[i % newsSourcesPolicy.length];
        final author = 'Reporter ${String.fromCharCode(65 + (i % 26))}';

        final trend = TrendModel(
          id: 'political_mock_$i',
          title: title,
          category: 'political',
          summary: '$source • $author',
          content:
              'Breaking news: $title\n\nThis is a comprehensive overview of the latest developments in this important policy matter. Our team of analysts has gathered the most recent information and insights.',
          date: now.subtract(Duration(hours: i * 2)),
          source: source,
          fetchedAt: now,
          extras: {
            'url': 'https://news.example.com/article_$i', // Mock URL
            'imageUrl':
                'https://via.placeholder.com/300x200/1e3a8a/ffffff?text=News',
            'author': author,
            'source': source,
            'description':
                'Latest developments in ${title.toLowerCase()}. Read more for details.',
          },
        );

        // Save to Firestore but do not overwrite engagement fields
        final polMap = Map<String, dynamic>.from(trend.toMap());
        polMap.remove('likes');
        polMap.remove('likedBy');
        polMap.remove('comments');
        await _db
            .collection('trends')
            .doc('political_mock_$i')
            .set(polMap, SetOptions(merge: true));

        trends.add(trend);
      }

      // ignore: avoid_print
      print('Generated ${trends.length} mock political trends');
      return trends;
    } catch (e) {
      // ignore: avoid_print
      print('MockTrendDataGenerator.generateMockPoliticalTrends error: $e');
      rethrow;
    }
  }

  /// Generate all mock trends
  Future<void> generateAllMockTrends() async {
    try {
      await Future.wait([
        generateMockYoutubeTrends(),
        generateMockStockTrends(),
        generateMockPoliticalTrends(),
      ]);
      // ignore: avoid_print
      print('✓ All mock trends generated successfully!');
    } catch (e) {
      // ignore: avoid_print
      print('MockTrendDataGenerator.generateAllMockTrends error: $e');
      rethrow;
    }
  }

  /// Clear all mock trends (for testing)
  Future<void> clearMockTrends() async {
    try {
      final batch = _db.batch();
      final snapshot = await _db.collection('trends').get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      // ignore: avoid_print
      print('✓ Cleared all mock trends');
    } catch (e) {
      // ignore: avoid_print
      print('MockTrendDataGenerator.clearMockTrends error: $e');
      rethrow;
    }
  }
}
