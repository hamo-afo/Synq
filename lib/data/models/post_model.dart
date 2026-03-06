import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model representing a user-generated post in the Synq app.
///
/// Encapsulates post content including the text, optional image URL, creation timestamp,
/// and category. Used for displaying posts in feeds, managing user-generated content,
/// and facilitating social interactions within the application.
class PostModel {
  final String id;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime? createdAt;
  final String? category; // new optional field

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.createdAt,
    this.category,
  });

  PostModel copyWith({
    String? id,
    String? userId,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    String? category,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
    if (category != null) map['category'] = category;
    return map;
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      category: map['category'],
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is PostModel && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;
}
