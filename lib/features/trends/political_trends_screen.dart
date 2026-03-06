// lib/features/trends/political_trends_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/trend_repository.dart';
import '../../data/models/trend_model.dart';
import '../../widgets/trend_card.dart';
import '../../routing/route_names.dart';

class PoliticalTrendsScreen extends StatefulWidget {
  const PoliticalTrendsScreen({super.key});

  @override
  State<PoliticalTrendsScreen> createState() => _PoliticalTrendsScreenState();
}

class _PoliticalTrendsScreenState extends State<PoliticalTrendsScreen> {
  final TrendRepository _repo = TrendRepository();
  late Future<List<TrendModel>> _future;

  @override
  void initState() {
    super.initState();
    _loadTrends();
  }

  void _loadTrends() {
    setState(() {
      _future = _repo.fetchPoliticalTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Political Trends'),
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
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final msg = snapshot.error.toString();
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

            final trends = snapshot.data ?? [];

            if (trends.isEmpty) {
              return const Center(child: Text('No political trends found'));
            }

            return ListView.builder(
              itemCount: trends.length,
              itemBuilder: (context, index) => TrendCard(trend: trends[index]),
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
