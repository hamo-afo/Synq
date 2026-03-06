// lib/features/trends/stock_trends_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/trend_repository.dart';
import '../../data/models/trend_model.dart';
import '../../widgets/trend_card.dart';
import '../../routing/route_names.dart';

class StockTrendsScreen extends StatefulWidget {
  const StockTrendsScreen({super.key});

  @override
  State<StockTrendsScreen> createState() => _StockTrendsScreenState();
}

class _StockTrendsScreenState extends State<StockTrendsScreen> {
  final TrendRepository _repo = TrendRepository();
  late Future<List<TrendModel>> _future;

  @override
  void initState() {
    super.initState();
    _loadTrends();
  }

  void _loadTrends() {
    setState(() {
      _future = _repo.fetchStockTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Trends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.trendSearch),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTrends();
          await _future;
        },
        child: FutureBuilder<List<TrendModel>>(
          future: _future,
          builder: (ctx, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              final msg = snap.error.toString();
              final link = _extractFirstUrl(msg);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Error loading trends',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SelectableText(msg),
                      if (link != null) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _openUrl(link),
                          child: const Text('Open Firestore index link'),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }

            final items = snap.data ?? [];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => TrendCard(trend: items[i]),
            );
          },
        ),
      ),
    );
  }

  String? _extractFirstUrl(String text) {
    final regex = RegExp(r"https?://[^\s)]+", caseSensitive: false);
    final match = regex.firstMatch(text);
    return match?.group(0);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
