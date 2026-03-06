import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/report_model.dart';

/// State management provider for report data and generation.
///
/// Manages the list of reports, handles report creation and updates, and provides
/// real-time synchronization with Firestore. Widgets consume this provider to display
/// reports and trigger report generation, with automatic UI updates when data changes.
class ReportProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ReportModel> reports = [];

  /// Send a new report to Firestore
  Future<void> sendReport(ReportModel report) async {
    await _db.collection('reports').add(report.toMap());
    await fetchReports(); // refresh local list
  }

  /// Fetch all reports from Firestore
  Future<void> fetchReports() async {
    final snapshot = await _db.collection('reports').get();
    reports = snapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  /// Stream of reports for real-time updates
  Stream<List<ReportModel>> getReports() {
    return _db.collection('reports').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ReportModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
