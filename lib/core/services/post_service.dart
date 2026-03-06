// lib/core/services/post_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/post_model.dart';
import '../../data/firebase/firestore_paths.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  /// Create a post in Firestore. Returns the created DocumentReference.
  Future<DocumentReference<Map<String, dynamic>>> createPost(
    PostModel post,
  ) async {
    final data = post.toMap();
    if (data['createdAt'] == null || data['createdAt'].toString().isEmpty) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    return await _db.collection(FirestorePaths.posts()).add(data);
  }

  /// Pick an image from the gallery. Returns an [XFile] or null if cancelled.
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      return file;
    } catch (e) {
      // optionally log
      return null;
    }
  }

  /// Pick an image from the camera. Returns an [XFile] or null if cancelled.
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      return file;
    } catch (e) {
      // optionally log
      return null;
    }
  }

  /// Example helper to upload an image file to Firestore as a post attachment.
  /// (Implement upload to Firebase Storage separately; this is a placeholder.)
  Future<void> createPostWithAttachment(
    PostModel post, {
    String? attachmentUrl,
  }) async {
    final data = post.toMap();
    if (attachmentUrl != null) data['attachments'] = [attachmentUrl];
    if (data['createdAt'] == null || data['createdAt'].toString().isEmpty) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await _db.collection(FirestorePaths.posts()).add(data);
  }
}
