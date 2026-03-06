import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_paths.dart';

class FirestoreRefs {
  static CollectionReference users = FirebaseFirestore.instance.collection(
    FirestorePaths.users(),
  );

  static CollectionReference posts = FirebaseFirestore.instance.collection(
    FirestorePaths.posts(),
  );

  static CollectionReference trends = FirebaseFirestore.instance.collection(
    FirestorePaths.trends(),
  );

  static CollectionReference reports = FirebaseFirestore.instance.collection(
    FirestorePaths.reports(),
  );

  static CollectionReference stocks = FirebaseFirestore.instance.collection(
    FirestorePaths.stockData(),
  );
}
