import 'package:flutter/material.dart';

import '../../data/models/trend_model.dart';
import '../../data/repositories/trend_repository.dart';
import '../../widgets/trend_card.dart';

class TrendSearchScreen extends StatefulWidget {
  const TrendSearchScreen({super.key});

  @override
  State<TrendSearchScreen> createState() => _TrendSearchScreenState();
}

class _TrendSearchScreenState extends State<TrendSearchScreen> {
  final TrendRepository _repo = TrendRepository();
  final TextEditingController _searchController = TextEditingController();

  List<TrendModel> _allTrends = [];
  List<TrendModel> _filteredTrends = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrends();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadTrends() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final trends = await _repo.fetchAllTrends(limit: 100);
      if (!mounted) return;
      setState(() {
        _allTrends = trends;
        _filteredTrends = trends;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load trends: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredTrends = _allTrends;
      });
      return;
    }

    setState(() {
      _filteredTrends = _allTrends.where((t) {
        final title = t.title.toLowerCase();
        final summary = t.summary.toLowerCase();
        final content = t.content.toLowerCase();
        final category = t.category.toLowerCase();
        return title.contains(query) ||
            summary.contains(query) ||
            content.contains(query) ||
            category.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by title, summary, category...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadTrends,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (_filteredTrends.isEmpty) {
      return const Center(
        child: Text('No trends match your search.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrends,
      child: ListView.builder(
        itemCount: _filteredTrends.length,
        itemBuilder: (context, index) {
          final trend = _filteredTrends[index];
          return TrendCard(trend: trend);
        },
      ),
    );
  }
}


