// lib/data/firebase/firestore_paths.dart
class FirestorePaths {
  static String users() => "users";
  static String user(String uid) => "users/$uid";

  static String posts() => "posts";
  static String post(String id) => "posts/$id";

  static String comments(String postId) => "posts/$postId/comments";

  static String trends() => "trends";

  static String reports() => "reports";

  static String stockData() => "stocks";
}
