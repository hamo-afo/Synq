import 'package:flutter/material.dart';

class GenerateReportButtonScreen extends StatelessWidget {
  const GenerateReportButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Reports")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: call ReportService().generateWeeklyReport()
          },
          child: const Text("Generate Now"),
        ),
      ),
    );
  }
}
