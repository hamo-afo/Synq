// lib/core/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../firebase_options.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user!;
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: user.email ?? email,
        role: 'user',
        createdAt: DateTime.now(),
      );

      // Try to create the Firestore user document. If Firestore is
      // unavailable or the write fails, still return the userModel so
      // authentication succeeds and the app can continue offline.
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      } catch (e) {
        // ignore: avoid_print
        print('Firestore write failed during register: $e');
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    } catch (e, st) {
      // Log the full exception and stack trace to help debugging Pigeon issues.
      // ignore: avoid_print
      print('AuthService.registerWithEmail error: $e');
      // ignore: avoid_print
      print(st);

      final err = e.toString();
      // Detect the Pigeon type-cast mismatch and attempt a REST fallback.
      if (err.contains('PigeonUserDetails') || err.contains('List<Object?>')) {
        try {
          return await _restSignUp(
              name: name, email: email, password: password);
        } catch (e2) {
          throw Exception('Registration failed (fallback): $e2');
        }
      }
      throw Exception('Registration failed: $e');
    }
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user!;
      try {
        final snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (!snapshot.exists) {
          final newModel = UserModel(
            uid: user.uid,
            name: '',
            email: user.email ?? email,
            role: 'user',
            createdAt: DateTime.now(),
          );
          try {
            await _firestore
                .collection('users')
                .doc(user.uid)
                .set(newModel.toMap());
          } catch (e) {
            // ignore: avoid_print
            print('Firestore write failed during sign-in path: $e');
          }
          return newModel;
        }
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      } catch (e) {
        // Firestore is unavailable; return a minimal UserModel based on auth
        // information so the app can continue.
        // ignore: avoid_print
        print('Firestore read failed during sign-in: $e');
        return UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? email,
          role: 'user',
          createdAt: DateTime.now(),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign in failed');
    } catch (e, st) {
      // Log the full exception and stack trace to help debugging Pigeon issues.
      // This will appear in the device/emulator logs.
      // ignore: avoid_print
      print('AuthService.signInWithEmail error: $e');
      // ignore: avoid_print
      print(st);

      final err = e.toString();
      // Detect the Pigeon type-cast mismatch and attempt a REST fallback.
      if (err.contains('PigeonUserDetails') || err.contains('List<Object?>')) {
        try {
          return await _restSignIn(email: email, password: password);
        } catch (e2) {
          throw Exception('Sign in failed (fallback): $e2');
        }
      }
      throw Exception('Sign in failed: $e');
    }
  }

  /// Fallback sign-in using Firebase REST API if platform channel Pigeon fails.
  Future<UserModel> _restSignIn({
    required String email,
    required String password,
  }) async {
    final apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (resp.statusCode != 200) {
      // ignore: avoid_print
      print('REST sign-in HTTP ${resp.statusCode}: ${resp.body}');
      throw Exception('REST sign-in failed: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;

    final localId = data['localId'] as String?;
    final emailResp = data['email'] as String? ?? email;

    if (localId == null) {
      throw Exception('REST sign-in: missing localId');
    }

    try {
      final snapshot = await _firestore.collection('users').doc(localId).get();
      if (!snapshot.exists) {
        final newModel = UserModel(
          uid: localId,
          name: '',
          email: emailResp,
          role: 'user',
          createdAt: DateTime.now(),
        );
        try {
          await _firestore
              .collection('users')
              .doc(localId)
              .set(newModel.toMap());
        } catch (e) {
          // ignore: avoid_print
          print('Firestore write failed during REST sign-in: $e');
        }
        return newModel;
      }
      return UserModel.fromMap(snapshot.data()!, snapshot.id);
    } catch (e) {
      // ignore: avoid_print
      print('Firestore read failed during REST sign-in: $e');
      return UserModel(
        uid: localId,
        name: '',
        email: emailResp,
        role: 'user',
        createdAt: DateTime.now(),
      );
    }
  }

  /// Fallback sign-up using Firebase REST API if platform channel Pigeon fails.
  Future<UserModel> _restSignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (resp.statusCode != 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final errorMsg = body['error']['message'] as String?;

      // ignore: avoid_print
      print('REST sign-up HTTP ${resp.statusCode}: ${resp.body}');

      // If EMAIL_EXISTS, the account was created during the failed Pigeon attempt.
      // Log in instead to recover gracefully.
      if (errorMsg == 'EMAIL_EXISTS') {
        // ignore: avoid_print
        print('Email already exists; attempting sign-in as recovery...');
        try {
          return await _restSignIn(email: email, password: password);
        } catch (e) {
          throw Exception('Email exists but sign-in failed: $e');
        }
      }

      throw Exception('REST sign-up failed: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;

    final localId = data['localId'] as String?;
    final emailResp = data['email'] as String? ?? email;

    if (localId == null) {
      throw Exception('REST sign-up: missing localId');
    }

    // Create Firestore user document; on failure, still return the model so
    // authentication completes.
    final userModel = UserModel(
      uid: localId,
      name: name,
      email: emailResp,
      role: 'user',
      createdAt: DateTime.now(),
    );
    try {
      await _firestore.collection('users').doc(localId).set(userModel.toMap());
    } catch (e) {
      // ignore: avoid_print
      print('Firestore write failed during REST sign-up: $e');
    }
    return userModel;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Reset failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromMap(snapshot.data()!, snapshot.id);
  }

  Future<void> ensureUserDocument(
    User user, {
    String? name,
    String? role,
  }) async {
    final ref = _firestore.collection('users').doc(user.uid);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      final model = UserModel(
        uid: user.uid,
        name: name ?? '',
        email: user.email ?? '',
        role: role ?? 'user',
        createdAt: DateTime.now(),
      );
      await ref.set(model.toMap());
    }
  }
}
