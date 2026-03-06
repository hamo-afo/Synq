import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/report_model.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Report Type'),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Report Content',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (user == null) return;
                    if (typeController.text.isEmpty ||
                        titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All fields are required'),
                        ),
                      );
                      return;
                    }

                    ReportModel report = ReportModel(
                      id: '',
                      type: typeController.text.trim(),
                      title: titleController.text.trim(),
                      description: contentController.text.trim(),
                      generatedAt: DateTime.now(),
                    );

                    await reportProvider.sendReport(report);

                    typeController.clear();
                    titleController.clear();
                    contentController.clear();
                  },
                  child: const Text('Submit Report'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ReportModel>>(
              stream: reportProvider.getReports(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reports = snapshot.data!;
                if (reports.isEmpty) {
                  return const Center(child: Text('No reports yet.'));
                }
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return ListTile(
                      title: Text(report.title),
                      subtitle: Text(report.description),
                      trailing: Text(
                        report.generatedAt != null
                            ? '${report.generatedAt!.toLocal()}'.split(' ')[0]
                            : '',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
