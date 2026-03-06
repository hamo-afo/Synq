import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_paths.dart';

class FirestoreQueries {
  static Query latestPosts() {
    return FirebaseFirestore.instance
        .collection(FirestorePaths.posts())
        .orderBy("createdAt", descending: true);
  }

  static Query trendsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection(FirestorePaths.trends())
        .where("category", isEqualTo: category);
  }

  static Query commentsForPost(String postId) {
    return FirebaseFirestore.instance
        .collection(FirestorePaths.comments(postId))
        .orderBy("createdAt");
  }
}
