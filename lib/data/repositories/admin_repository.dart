// lib/data/repositories/admin_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../firebase/firestore_paths.dart';

class AdminRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream({int limit = 100}) {
    return _db
        .collection(FirestorePaths.users())
        .orderBy('name', descending: false)
        .limit(limit)
        .snapshots()
        .handleError((e) {
      // ignore: avoid_print
      print('AdminRepository.usersStream error: $e');
    });
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _db.collection(FirestorePaths.users()).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection(FirestorePaths.users()).doc(uid).delete();
  }

  /// Remove duplicate trend documents. If [category] is provided, only
  /// dedupe trends in that category (e.g., 'political', 'stock', 'youtube').
  /// Returns number of deleted documents.
  Future<int> dedupeTrends({String? category}) async {
    final coll = _db.collection('trends');
    Query<Map<String, dynamic>> q = coll;
    if (category != null && category.isNotEmpty) {
      q = q.where('category', isEqualTo: category);
    }

    final snapshot = await q.get();
    final docs = snapshot.docs;

    // Group by a stable key: prefer extras.videoId / extras.symbol / extras.url, fallback to title
    final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        groups = {};

    for (final d in docs) {
      final data = d.data();
      String key = '';
      try {
        final extras = data['extras'] as Map<String, dynamic>?;
        key = extras?['videoId']?.toString() ??
            extras?['symbol']?.toString() ??
            extras?['url']?.toString() ??
            data['title']?.toString() ??
            '';
      } catch (_) {
        key = data['title']?.toString() ?? '';
      }
      if (key.isEmpty) key = d.id; // fallback unique key

      groups.putIfAbsent(key, () => []).add(d);
    }

    var deleted = 0;
    final batch = _db.batch();

    for (final entry in groups.entries) {
      final list = entry.value;
      if (list.length <= 1) continue;

      // Sort by 'date' descending so we keep the latest
      list.sort((a, b) {
        final aDate = (a.data()['date'] is Timestamp)
            ? (a.data()['date'] as Timestamp).toDate()
            : DateTime.now();
        final bDate = (b.data()['date'] is Timestamp)
            ? (b.data()['date'] as Timestamp).toDate()
            : DateTime.now();
        return bDate.compareTo(aDate);
      });

      // Keep first (latest), delete rest
      for (var i = 1; i < list.length; i++) {
        batch.delete(list[i].reference);
        deleted += 1;
      }
    }

    if (deleted > 0) await batch.commit();
    return deleted;
  }
}
