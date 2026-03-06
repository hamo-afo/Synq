// lib/features/reports/report_card.dart
import 'package:flutter/material.dart';
import '../../data/models/report_model.dart';
import '../../core/utils/formatters.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final date = report.generatedAt ?? DateTime.now();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(report.title),
        subtitle: Text(
          '${Formatters.formatDate(date)} • ${report.description}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // open detailed report view if you have one
        },
      ),
    );
  }
}
