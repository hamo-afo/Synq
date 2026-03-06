import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Database Viewer"),
            onTap: () => Navigator.pushNamed(context, '/databaseViewer'),
          ),
          ListTile(
            title: const Text("Generate Reports"),
            onTap: () => Navigator.pushNamed(context, '/generateReport'),
          ),
          ListTile(
            title: const Text("User Management"),
            onTap: () => Navigator.pushNamed(context, '/userManagement'),
          ),
        ],
      ),
    );
  }
}
