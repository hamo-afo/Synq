import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/trend_model.dart';

class TrendRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// One-time fetch: Get all trends under a specific category
  Future<List<TrendModel>> fetchTrendsByCategory(String category) async {
    final q = await _firestore
        .collection('trends')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .get();

    return q.docs
        .map((d) => TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  /// =======================
  /// Convenience fetch methods
  /// =======================

  Future<List<TrendModel>> fetchPoliticalTrends() =>
      fetchTrendsByCategory('political');

  Future<List<TrendModel>> fetchYoutubeTrends() =>
      fetchTrendsByCategory('youtube');

  Future<List<TrendModel>> fetchStockTrends() => fetchTrendsByCategory('stock');

  Future<List<TrendModel>> fetchCryptoTrends() =>
      fetchTrendsByCategory('crypto');

  /// =======================
  /// Real-time stream methods
  /// =======================

  Stream<List<TrendModel>> trendsStreamByCategory(String category) {
    return _firestore
        .collection('trends')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) =>
                    TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id),
              )
              .toList(),
        );
  }

  Stream<List<TrendModel>> politicalTrendsStream() =>
      trendsStreamByCategory('political');

  Stream<List<TrendModel>> youtubeTrendsStream() =>
      trendsStreamByCategory('youtube');

  Stream<List<TrendModel>> stockTrendsStream() =>
      trendsStreamByCategory('stock');

  Stream<List<TrendModel>> cryptoTrendsStream() =>
      trendsStreamByCategory('crypto');
}
