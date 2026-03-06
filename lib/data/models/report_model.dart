import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model representing trend reports (daily, weekly, or monthly).
///
/// Stores report metadata including type (daily/weekly/monthly), title, description,
/// and generation timestamp. This model is used to display analytical reports to users
/// and organize trend analysis by time periods.
class ReportModel {
  final String id;
  final String type; // daily/weekly/monthly
  final String title;
  final String description;
  final DateTime? generatedAt;

  ReportModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.generatedAt,
  });

  ReportModel copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    DateTime? generatedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'generatedAt': generatedAt != null
          ? Timestamp.fromDate(generatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    return ReportModel(
      id: id,
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      generatedAt: map['generatedAt'] is Timestamp
          ? (map['generatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}
