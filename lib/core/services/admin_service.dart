// lib/core/services/admin_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/firebase/firestore_paths.dart'; // correct path

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers({int limit = 100}) {
    return _db
        .collection(FirestorePaths.users())
        .orderBy('name', descending: false)
        .limit(limit)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) {
    return _db.collection(FirestorePaths.users()).doc(uid).get();
  }

  Future<void> deleteUser(String uid) =>
      _db.collection(FirestorePaths.users()).doc(uid).delete();

  Future<void> setAdmin(String uid, bool isAdmin) async {
    await _db
        .collection(FirestorePaths.users())
        .doc(uid)
        .set({'isAdmin': isAdmin}, SetOptions(merge: true));
  }

  Future<void> setBanned(String uid, bool banned) async {
    await _db
        .collection(FirestorePaths.users())
        .doc(uid)
        .set({'banned': banned}, SetOptions(merge: true));
  }

  /// Purge trends older than [days]. Returns number of deleted documents.
  Future<int> purgeOldTrends({required int days}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final cutoffTs = Timestamp.fromDate(cutoff);
    int totalDeleted = 0;

    while (true) {
      final snap = await _db
          .collection(FirestorePaths.trends())
          .where('date', isLessThan: cutoffTs)
          .limit(500)
          .get();
      if (snap.docs.isEmpty) break;

      final batch = _db.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      totalDeleted += snap.docs.length;
      if (snap.docs.length < 500) break;
    }

    return totalDeleted;
  }
}
