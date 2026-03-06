// lib/data/repositories/post_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../firebase/firestore_paths.dart';

/// Repository for managing user-generated posts and comments in Firestore.
///
/// Provides methods to create, read, update, and delete posts. Handles post metadata
/// like timestamps, user associations, and manages comments on posts. Serves as the
/// data access layer for post-related operations throughout the app.
class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create post
  Future<DocumentReference<Map<String, dynamic>>> createPost(
    PostModel post,
  ) async {
    final data = post.toMap();
    if (data['createdAt'] == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    return _db.collection(FirestorePaths.posts()).add(data);
  }

  /// Stream posts
  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream({int limit = 50}) {
    return _db
        .collection(FirestorePaths.posts())
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((e) {
      // ignore: avoid_print
      print('PostRepository.postsStream error: $e');
    });
  }

  /// Add comment
  Future<DocumentReference<Map<String, dynamic>>> addComment(
    CommentModel comment,
  ) async {
    final data = comment.toMap();
    if (data['createdAt'] == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    return _db.collection(FirestorePaths.comments(comment.postId)).add(data);
  }

  /// Stream comments
  Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream(
    String postId, {
    int limit = 100,
  }) {
    return _db
        .collection(FirestorePaths.comments(postId))
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .snapshots()
        .handleError((e) {
      // ignore: avoid_print
      print('PostRepository.commentsStream error: $e');
    });
  }

  /// Get single post
  Future<PostModel?> getPostById(String id) async {
    final doc = await _db.collection(FirestorePaths.posts()).doc(id).get();
    if (!doc.exists) return null;
    return PostModel.fromMap(doc.data()!, doc.id);
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    await _db.collection(FirestorePaths.posts()).doc(postId).delete();
  }
}
