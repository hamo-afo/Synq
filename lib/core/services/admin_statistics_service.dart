import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/post_model.dart';

class AdminStatisticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getTotalPosts() async {
    final snapshot = await _db.collection("posts").get();
    return snapshot.docs.length;
  }

  Future<int> getTotalComments() async {
    int total = 0;
    final posts = await _db.collection("posts").get();

    for (var doc in posts.docs) {
      final comments = await _db
          .collection("posts")
          .doc(doc.id)
          .collection("comments")
          .get();

      total += comments.docs.length;
    }

    return total;
  }

  Future<int> getTotalUsers() async {
    final snapshot = await _db.collection("users").get();
    return snapshot.docs.length;
  }

  Future<List<PostModel>> getTopPosts() async {
    final snap = await _db
        .collection("posts")
        .orderBy("likes", descending: true)
        .limit(5)
        .get();

    return snap.docs
        .map(
          (doc) =>
              PostModel.fromMap(doc.data(), doc.id),
        )
        .toList();
  }
}
