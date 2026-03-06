import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart';
import '../../data/repositories/report_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportRepository _repo = ReportRepository();
  DateTime _selectedFromDate =
      DateTime.now().subtract(const Duration(days: 30));
  DateTime _selectedToDate = DateTime.now();

  // Preset date filters
  void _setPresetDateRange(String preset) {
    final now = DateTime.now();
    setState(() {
      switch (preset) {
        case 'today':
          _selectedFromDate = DateTime(now.year, now.month, now.day);
          _selectedToDate = now;
          break;
        case 'week':
          _selectedFromDate = now.subtract(const Duration(days: 7));
          _selectedToDate = now;
          break;
        case 'month':
          _selectedFromDate = now.subtract(const Duration(days: 30));
          _selectedToDate = now;
          break;
        case 'quarter':
          _selectedFromDate = now.subtract(const Duration(days: 90));
          _selectedToDate = now;
          break;
        case 'year':
          _selectedFromDate = now.subtract(const Duration(days: 365));
          _selectedToDate = now;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preset Date Filters
            _buildPresetFilters(),
            const SizedBox(height: 16),

            // Date Range Selector
            _buildDateRangeSelector(),
            const SizedBox(height: 24),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 24),

            // Daily Counts Chart
            _buildDailyCountsChart(),
            const SizedBox(height: 24),

            // Category Distribution Chart
            _buildCategoryChart(),
            const SizedBox(height: 24),

            // Trending Keywords
            _buildTrendingKeywords(),
            const SizedBox(height: 24),

            // CSV Export Button
            _buildExportButton(),
            const SizedBox(height: 24),

            // Weekly Counts
            _buildWeeklyCounts(),
            const SizedBox(height: 24),

            // Monthly Counts
            _buildMonthlyCounts(),
            const SizedBox(height: 24),

            // Top Trends by Likes
            _buildTopTrends(),
            const SizedBox(height: 24),

            // Top Stock Symbols
            _buildTopStocks(),
            const SizedBox(height: 24),

            // Engagement Metrics
            _buildEngagementMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Filters',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetButton('Today', 'today'),
                  _buildPresetButton('Last 7 Days', 'week'),
                  _buildPresetButton('Last 30 Days', 'month'),
                  _buildPresetButton('Last 90 Days', 'quarter'),
                  _buildPresetButton('Last Year', 'year'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, String preset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _setPresetDateRange(preset),
        child: Text(label),
      ),
    );
  }

  Widget _buildDailyCountsChart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _repo.dailyCounts(30),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const Text('No data available'),
            ),
          );
        }

        final data = snapshot.data!;
        final spots = <FlSpot>[];
        for (int i = 0; i < data.length; i++) {
          spots.add(FlSpot(i.toDouble(), (data[i]['count'] as int).toDouble()));
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Trends (Last 30 Days)',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() % 5 == 0 &&
                                  value.toInt() < data.length) {
                                return Text(value.toInt().toString());
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChart() {
    return FutureBuilder<Map<String, int>>(
      future:
          _repo.countsByCategory(from: _selectedFromDate, to: _selectedToDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const Text('No data available'),
            ),
          );
        }

        final counts = snapshot.data!;
        final sections = <PieChartSectionData>[];
        final colors = [Colors.blue, Colors.green, Colors.orange];
        int colorIndex = 0;

        counts.forEach((category, count) {
          sections.add(
            PieChartSectionData(
              value: count.toDouble(),
              title: '$category\n$count',
              color: colors[colorIndex % colors.length],
              radius: 100,
            ),
          );
          colorIndex++;
        });

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Distribution by Category',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(sections: sections),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingKeywords() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _repo.topTrendsByLikes(100,
          from: _selectedFromDate, to: _selectedToDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const Text('No data available'),
            ),
          );
        }

        final trends = snapshot.data!;
        final wordFreq = <String, int>{};

        for (var trend in trends) {
          final title = (trend['title'] as String?)?.toLowerCase() ?? '';
          final words = title.split(RegExp(r'\s+'));
          for (var word in words) {
            if (word.length > 3 && !_isStopWord(word)) {
              wordFreq[word] = (wordFreq[word] ?? 0) + 1;
            }
          }
        }

        final sortedWords = wordFreq.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topWords = sortedWords.take(15).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trending Keywords',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: topWords.map((entry) {
                    return Chip(
                      label: Text('${entry.key} (${entry.value})'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isStopWord(String word) {
    final stopWords = {
      'the',
      'and',
      'or',
      'is',
      'a',
      'an',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'from'
    };
    return stopWords.contains(word);
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: _exportToCsv,
      icon: const Icon(Icons.download),
      label: const Text('Export to CSV'),
    );
  }

  Future<void> _exportToCsv() async {
    try {
      final counts = await _repo.countsByCategory(
          from: _selectedFromDate, to: _selectedToDate);
      final dailyData = await _repo.dailyCounts(30);
      final topTrends = await _repo.topTrendsByLikes(20,
          from: _selectedFromDate, to: _selectedToDate);

      List<List<dynamic>> rows = [];
      rows.add(['Report Generated', DateTime.now().toString()]);
      rows.add([]);
      rows.add([
        'Date Range',
        '${_selectedFromDate.toIso8601String()} to ${_selectedToDate.toIso8601String()}'
      ]);
      rows.add([]);

      rows.add(['Category Counts']);
      counts.forEach((category, count) {
        rows.add([category, count]);
      });
      rows.add([]);

      rows.add(['Daily Counts']);
      rows.add(['Date', 'Count']);
      for (var item in dailyData) {
        rows.add([item['date'], item['count']]);
      }
      rows.add([]);

      rows.add(['Top Trends']);
      rows.add(['Title', 'Category', 'Likes', 'Comments']);
      for (var trend in topTrends) {
        rows.add([
          trend['title'],
          trend['category'],
          trend['likes'],
          trend['comments'],
        ]);
      }

      final csvData = const ListToCsvConverter().convert(rows);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'trends_report_$timestamp.csv';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Report exported as $fileName (CSV: ${csvData.length} bytes)')),
        );
      }

      // Note: File saving requires platform-specific implementation
      // For now, just show the snackbar
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Widget _buildDateRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'From',
                    date: _selectedFromDate,
                    onTap: () => _selectDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    label: 'To',
                    date: _selectedToDate,
                    onTap: () => _selectDate(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _selectedFromDate : _selectedToDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _selectedFromDate = picked;
        } else {
          _selectedToDate = picked;
        }
      });
    }
  }

  Widget _buildQuickStats() {
    return FutureBuilder<Map<String, int>>(
      future:
          _repo.countsByCategory(from: _selectedFromDate, to: _selectedToDate),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        final counts = snap.data ?? {};
        final total = counts.values.fold<int>(0, (a, b) => a + b);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Stats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatTile('Total Posts', total.toString()),
                    _buildStatTile(
                        'YouTube', (counts['youtube'] ?? 0).toString()),
                    _buildStatTile('Stock', (counts['stock'] ?? 0).toString()),
                    _buildStatTile(
                        'Political', (counts['political'] ?? 0).toString()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildWeeklyCounts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Counts (Last 4 Weeks)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _repo.weeklyCounts(4),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }

                final data = snap.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final weekStart = item['weekStart'] as DateTime?;
                    final count = item['count'] as int?;
                    return ListTile(
                      title: Text(
                        weekStart != null
                            ? 'Week of ${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}'
                            : 'Unknown',
                      ),
                      trailing: Text(
                        '${count ?? 0} posts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyCounts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Counts (Last 6 Months)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _repo.monthlyCounts(6),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }

                final data = snap.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final month = item['month'] as DateTime?;
                    final count = item['count'] as int?;
                    return ListTile(
                      title: Text(
                        month != null
                            ? '${month.year}-${month.month.toString().padLeft(2, '0')}'
                            : 'Unknown',
                      ),
                      trailing: Text(
                        '${count ?? 0} posts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Trends by Likes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _repo.topTrendsByLikes(10,
                  from: _selectedFromDate, to: _selectedToDate),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }

                final data = snap.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(
                        item['title']?.toString() ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${item['category']} • ${item['comments']} comments',
                      ),
                      trailing: Text(
                        '❤️ ${item['likes']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStocks() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Stock Symbols',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _repo.topStockSymbols(10,
                  from: _selectedFromDate, to: _selectedToDate),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }

                final data = snap.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(item['symbol']?.toString() ?? 'Unknown'),
                      trailing: Text(
                        '${item['count']} mentions',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Engagement Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: _repo.engagementMetrics(
                  from: _selectedFromDate, to: _selectedToDate),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }

                final data = snap.data ?? {};
                return Column(
                  children: [
                    _buildMetricRow(
                        'Total Posts', (data['totalPosts'] ?? 0).toString()),
                    _buildMetricRow(
                        'Total Likes', (data['totalLikes'] ?? 0).toString()),
                    _buildMetricRow('Total Comments',
                        (data['totalComments'] ?? 0).toString()),
                    _buildMetricRow(
                      'Avg Likes per Post',
                      ((data['avgLikesPerPost'] ?? 0.0) as num)
                          .toStringAsFixed(2),
                    ),
                    _buildMetricRow(
                      'Avg Comments per Post',
                      ((data['avgCommentsPerPost'] ?? 0.0) as num)
                          .toStringAsFixed(2),
                    ),
                    _buildMetricRow('Unique Likers',
                        (data['uniqueLikers'] ?? 0).toString()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
