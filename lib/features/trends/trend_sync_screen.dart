import 'package:flutter/material.dart';
import '../../core/services/api_trend_fetcher.dart';
import '../../core/services/mock_trend_data_generator.dart';

class TrendSyncScreen extends StatefulWidget {
  const TrendSyncScreen({super.key});

  @override
  State<TrendSyncScreen> createState() => _TrendSyncScreenState();
}

class _TrendSyncScreenState extends State<TrendSyncScreen> {
  final ApiTrendFetcher _fetcher = ApiTrendFetcher();
  final MockTrendDataGenerator _mockGenerator = MockTrendDataGenerator();
  bool _isSyncing = false;
  String _syncStatus = '';
  List<String> _syncLogs = [];

  void _addLog(String message) {
    setState(() {
      _syncLogs.add('${DateTime.now().toIso8601String()}: $message');
    });
  }

  Future<void> _syncYoutubeTrends() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing YouTube trends...';
    });
    _addLog('Starting YouTube trends sync...');

    try {
      final trends = await _fetcher.fetchAndSaveYoutubeTrends();
      _addLog('✓ YouTube trends synced: ${trends.length} items');
      setState(() {
        _syncStatus = 'YouTube trends synced: ${trends.length} items';
      });
    } catch (e) {
      _addLog('✗ YouTube sync failed: $e');
      setState(() {
        _syncStatus = 'YouTube sync failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _syncStockTrends() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing stock trends...';
    });
    _addLog('Starting stock trends sync...');

    try {
      final trends = await _fetcher.fetchAndSaveStockTrends();
      _addLog('✓ Stock trends synced: ${trends.length} items');
      setState(() {
        _syncStatus = 'Stock trends synced: ${trends.length} items';
      });
    } catch (e) {
      _addLog('✗ Stock sync failed: $e');
      setState(() {
        _syncStatus = 'Stock sync failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _syncPoliticalTrends() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing political trends...';
    });
    _addLog('Starting political trends sync...');

    try {
      final trends = await _fetcher.fetchAndSavePoliticalTrends();
      _addLog('✓ Political trends synced: ${trends.length} items');
      setState(() {
        _syncStatus = 'Political trends synced: ${trends.length} items';
      });
    } catch (e) {
      _addLog('✗ Political sync failed: $e');
      setState(() {
        _syncStatus = 'Political sync failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _syncAllTrends() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing all trends...';
      _syncLogs.clear();
    });
    _addLog('Starting all trends sync...');

    try {
      _addLog('Fetching YouTube trends...');
      final youtube = await _fetcher.fetchAndSaveYoutubeTrends();
      _addLog('✓ YouTube: ${youtube.length} items');

      _addLog('Fetching stock trends...');
      final stocks = await _fetcher.fetchAndSaveStockTrends();
      _addLog('✓ Stocks: ${stocks.length} items');

      _addLog('Fetching political news...');
      final political = await _fetcher.fetchAndSavePoliticalTrends();
      _addLog('✓ Political: ${political.length} items');

      final total = youtube.length + stocks.length + political.length;
      _addLog('✓ All trends synced successfully! Total: $total items');
      setState(() {
        _syncStatus = 'All trends synced! ($total items)';
      });
    } catch (e) {
      _addLog('✗ Sync failed: $e');
      setState(() {
        _syncStatus = 'Sync failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _generateMockData() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Generating mock data...';
      _syncLogs.clear();
    });
    _addLog('Starting mock data generation...');

    try {
      _addLog('Generating YouTube trends...');
      await _mockGenerator.generateMockYoutubeTrends();
      _addLog('✓ YouTube mock data: 10 items');

      _addLog('Generating stock trends...');
      await _mockGenerator.generateMockStockTrends();
      _addLog('✓ Stock mock data: 10 items');

      _addLog('Generating political news...');
      await _mockGenerator.generateMockPoliticalTrends();
      _addLog('✓ Political mock data: 10 items');

      _addLog('✓ Mock data generation complete! 30 items total');
      setState(() {
        _syncStatus = 'Mock data generated! (30 items) - Refresh trend screens';
      });
    } catch (e) {
      _addLog('✗ Mock data generation failed: $e');
      setState(() {
        _syncStatus = 'Mock data generation failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  Future<void> _clearAllTrends() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Trends?'),
        content: const Text('This will delete all trends from Firestore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSyncing = true;
      _syncStatus = 'Clearing trends...';
      _syncLogs.clear();
    });
    _addLog('Starting clear operation...');

    try {
      await _mockGenerator.clearMockTrends();
      _addLog('✓ All trends cleared');
      setState(() {
        _syncStatus = 'All trends cleared';
      });
    } catch (e) {
      _addLog('✗ Clear failed: $e');
      setState(() {
        _syncStatus = 'Clear failed: $e';
      });
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Trends'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status card
              Card(
                color: Colors.blueAccent.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sync Status',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _syncStatus.isEmpty ? 'Ready' : _syncStatus,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (_isSyncing) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sync buttons
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _syncYoutubeTrends,
                icon: const Icon(Icons.video_library),
                label: const Text('Sync YouTube Trends'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _syncStockTrends,
                icon: const Icon(Icons.trending_up),
                label: const Text('Sync Stock Trends'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _syncPoliticalTrends,
                icon: const Icon(Icons.newspaper),
                label: const Text('Sync Political News'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _generateMockData,
                icon: const Icon(Icons.data_usage),
                label: const Text('Generate Mock Data (Test)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _syncAllTrends,
                icon: const Icon(Icons.cloud_sync),
                label: const Text('Sync All Trends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isSyncing ? null : _clearAllTrends,
                icon: const Icon(Icons.delete),
                label: const Text('Clear All Trends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Info box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber.withOpacity(0.1),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ℹ️ Setup Required',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Get API keys from:\n'
                      '   • YouTube Data API: https://cloud.google.com/docs/authentication/api-keys\n'
                      '   • Alpha Vantage (Stocks): https://www.alphavantage.co\n'
                      '   • NewsAPI (Political): https://newsapi.org\n\n'
                      '2. Update the API keys in:\n'
                      '   • youtube_api_service.dart\n'
                      '   • stock_api_service.dart\n'
                      '   • political_news_api_service.dart\n\n'
                      '3. Click "Sync All Trends" to populate Firestore',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sync logs
              if (_syncLogs.isNotEmpty) ...[
                const Text(
                  'Sync Logs',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.withOpacity(0.05),
                  ),
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: _syncLogs.length,
                    itemBuilder: (_, i) => Text(
                      _syncLogs[_syncLogs.length - 1 - i],
                      style: const TextStyle(
                          fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
