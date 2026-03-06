// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_drawer.dart';
import 'trend_feed.dart';
import '../../core/services/api_trend_fetcher.dart';
import '../../routing/route_names.dart';

/// Main home screen displaying the trend feed and navigation to trend categories.
///
/// Serves as the primary dashboard after login, showing real-time trends from various
/// sources (YouTube, stocks, political news), with a navigation drawer for accessing
/// different trend categories, reports, settings, and admin features.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Fetch real data from APIs
      final fetcher = ApiTrendFetcher();
      final results = await Future.wait([
        fetcher.fetchAndSaveYoutubeTrends().then((_) => true).catchError((e) {
          // ignore: avoid_print
          print('YouTube API error: $e');
          return false; // Don't fail, just return false
        }),
        fetcher.fetchAndSaveStockTrends().then((_) => true).catchError((e) {
          // ignore: avoid_print
          print('Stock API error: $e');
          return false;
        }),
        fetcher.fetchAndSavePoliticalTrends().then((_) => true).catchError((e) {
          // ignore: avoid_print
          print('Political News API error: $e');
          return false;
        }),
      ]);

      if (mounted) {
        // Check if at least one source succeeded
        final anySuccess = results.contains(true);
        setState(() {
          _initialized = true;
          if (!anySuccess) {
            _error =
                'Unable to fetch from APIs. Showing cached data if available.';
          }
        });
      }
      // ignore: avoid_print
      print('✓ API data fetch completed');
    } catch (e) {
      // ignore: avoid_print
      print('Error initializing trends: $e');
      if (mounted) {
        setState(() {
          _error = 'Connection error. Showing cached trends if available: $e';
          _initialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synq'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.trendSearch),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: _initialized
          ? Stack(
              children: [
                const TrendFeed(), // Show trends in background even if there's an error
                if (_error != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.orange.withOpacity(0.9),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  size: 20, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Partial Connection',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(_error!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching latest trends...'),
                ],
              ),
            ),
    );
  }
}
