// lib/features/home/trend_feed.dart
import 'package:flutter/material.dart';
import '../../data/models/trend_model.dart';
import '../../data/repositories/trend_repository.dart';
import '../../widgets/trend_card.dart';

class TrendFeed extends StatefulWidget {
  const TrendFeed({super.key});

  @override
  State<TrendFeed> createState() => _TrendFeedState();
}

class _TrendFeedState extends State<TrendFeed> {
  final TrendRepository _repo = TrendRepository();
  late Future<List<TrendModel>> _future;

  @override
  void initState() {
    super.initState();
    // Fetch all trends from all categories
    _loadTrends();
  }

  void _loadTrends() {
    setState(() {
      _future = _repo.fetchAllTrends().then((trends) {
        // Shuffle the trends to mix categories
        final shuffled = List<TrendModel>.from(trends)..shuffle();
        return shuffled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrendModel>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final items = snap.data ?? [];
        if (items.isEmpty)
          return const Center(child: Text('No trends available'));

        return RefreshIndicator(
          onRefresh: () async {
            _loadTrends();
            await _future;
          },
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final trend = items[index];
              return TrendCard(trend: trend);
            },
          ),
        );
      },
    );
  }
}
