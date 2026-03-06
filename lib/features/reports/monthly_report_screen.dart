import 'package:flutter/material.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/report_repository.dart';
import 'report_card.dart';

class MonthlyReportScreen extends StatelessWidget {
  MonthlyReportScreen({super.key});

  final ReportRepository _repo = ReportRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Reports')),
      body: StreamBuilder<List<ReportModel>>(
        stream: _repo.reportsStream('reports/monthly'),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No monthly reports yet'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ReportCard(report: items[i]),
          );
        },
      ),
    );
  }
}
