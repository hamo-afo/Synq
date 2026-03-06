// lib/core/services/report_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/firebase/firestore_paths.dart'; // correct path

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchReports({int limit = 50}) {
    return _db
        .collection(FirestorePaths.reports())
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getReportById(String id) {
    return _db.collection(FirestorePaths.reports()).doc(id).get();
  }

  Future<void> deleteReport(String reportId) {
    return _db.collection(FirestorePaths.reports()).doc(reportId).delete();
  }
}
