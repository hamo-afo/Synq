import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  List posts = [];

  Future<void> fetchPosts() async {
    // TODO: Firestore fetch
    notifyListeners();
  }
}
