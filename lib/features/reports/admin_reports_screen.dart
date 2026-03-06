// lib/features/reports/admin_reports_screen.dart
import 'package:flutter/material.dart';
import 'daily_reports_screen.dart';
import 'weekly_report_screen.dart';
import 'monthly_report_screen.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DailyReportScreen(),
            WeeklyReportScreen(),
            MonthlyReportScreen(),
          ],
        ),
      ),
    );
  }
}
