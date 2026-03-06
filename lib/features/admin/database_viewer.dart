import 'package:flutter/material.dart';

class DatabaseViewer extends StatelessWidget {
  const DatabaseViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Database Viewer")),
      body: const Center(
        child: Text("TODO: Display Firestore collections here"),
      ),
    );
  }
}
