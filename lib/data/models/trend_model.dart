import 'package:cloud_firestore/cloud_firestore.dart';

class TrendModel {
  final String id;
  final String title;
  final String category; // political, youtube, stock
  final String summary; // short summary for list
  final String content; // detailed content for detail screen
  final String? source; // optional: where the trend came from
  final DateTime date; // trend date
  final DateTime? fetchedAt; // optional: when fetched
  final Map<String, dynamic>? extras; // optional: metadata (key-value)
  final int likes; // number of likes
  final List<String> likedBy; // list of user IDs who liked
  final List<Map<String, dynamic>> comments; // list of comments

  TrendModel({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    required this.date,
    this.source,
    this.fetchedAt,
    this.extras,
    this.likes = 0,
    this.likedBy = const [],
    this.comments = const [],
  });

  factory TrendModel.fromMap(Map<String, dynamic> map, String id) {
    return TrendModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      summary: map['summary'] ?? '',
      content: map['content'] ?? '',
      source: map['source'],
      date: (map['date'] as Timestamp).toDate(),
      fetchedAt: map['fetchedAt'] != null
          ? (map['fetchedAt'] as Timestamp).toDate()
          : null,
      extras: map['extras'] != null
          ? Map<String, dynamic>.from(map['extras'])
          : null,
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      comments: List<Map<String, dynamic>>.from(map['comments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'summary': summary,
      'content': content,
      'source': source,
      'date': Timestamp.fromDate(date),
      'fetchedAt': fetchedAt != null
          ? Timestamp.fromDate(fetchedAt!)
          : FieldValue.serverTimestamp(),
      'extras': extras,
      'likes': likes,
      'likedBy': likedBy,
      'comments': comments,
    };
  }
}
