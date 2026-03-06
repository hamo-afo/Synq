// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    final created = map['createdAt'];
    DateTime createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    } else if (created is String) {
      createdAt = DateTime.tryParse(created) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return UserModel(
      uid: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'user',
      createdAt: createdAt,
      isAdmin: map['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAdmin': isAdmin,
    };
  }
}
