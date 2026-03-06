import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is CommentModel && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;
}
