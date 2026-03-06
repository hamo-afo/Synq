// lib/core/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';

/// State management provider for user authentication and session management.
///
/// Manages global auth state including current user data, loading states, and
/// authentication operations. Notifies listeners when auth state changes, enabling
/// reactive updates across the UI. Serves as the single source of truth for auth info.
class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool isLoading = false;
  UserModel? user;

  /// Load current user
  Future<void> loadCurrentUser() async {
    isLoading = true;
    notifyListeners();
    try {
      user = await _service.getCurrentUserModel();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load current user: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Login
  Future<UserModel> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final u = await _service.signInWithEmail(
        email: email,
        password: password,
      );
      user = u;
      return u;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Register
  Future<UserModel> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final u = await _service.registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      user = u;
      return u;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Password reset
  Future<void> sendPasswordReset(String email) async {
    await _service.sendPasswordReset(email);
  }

  /// Sign out
  Future<void> signOut() async {
    await _service.signOut();
    user = null;
    notifyListeners();
  }

  /// Added logout method to match HomeScreen
  Future<void> logout() async {
    await signOut();
  }
}
