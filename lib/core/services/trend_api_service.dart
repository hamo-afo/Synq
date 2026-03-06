// lib/core/services/trend_api_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/firebase/firestore_paths.dart'; // correct path

class TrendApiService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchTrends({int limit = 50}) {
    return _db
        .collection(FirestorePaths.trends())
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTrendById(String id) {
    return _db.collection(FirestorePaths.trends()).doc(id).get();
  }
}
