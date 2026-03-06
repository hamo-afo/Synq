// lib/features/trends/trend_detail_screen.dart
import 'package:flutter/material.dart';
import '../../data/models/trend_model.dart';
import '../../core/utils/formatters.dart';

class TrendDetailScreen extends StatelessWidget {
  final TrendModel trend;
  const TrendDetailScreen({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trend.title, overflow: TextOverflow.ellipsis)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              trend.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Source: ${trend.source}'),
            SizedBox(height: 8),
            Text(
              'Fetched: ${Formatters.formatDate(trend.fetchedAt ?? trend.date)}',
            ),

            SizedBox(height: 16),
            Text(trend.summary),
            if (trend.extras != null && trend.extras!.isNotEmpty)
              ...trend.extras!.entries.map(
                (e) => ListTile(
                  title: Text(e.key),
                  subtitle: Text(e.value?.toString() ?? ''),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
