// lib/core/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
// correct path from core/services

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);
  DocumentReference<Map<String, dynamic>> document(String path) =>
      _db.doc(path);

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(String path) =>
      _db.doc(path).get();
  Future<void> setDoc(String path, Map<String, dynamic> data) =>
      _db.doc(path).set(data, SetOptions(merge: true));
  Future<void> deleteDoc(String path) => _db.doc(path).delete();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String path, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(path);
    if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
    if (limit != null) query = query.limit(limit);
    return query.snapshots().handleError((e) {
      // ignore: avoid_print
      print('FirestoreService.streamCollection error: $e');
      // Let the stream error propagate (or callers can handle) —
      // returning a QuerySnapshot isn't supported by the API.
    });
  }
}
