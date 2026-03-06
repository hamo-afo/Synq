import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trend_model.dart';

class TrendRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of all trends (if needed)
  Stream<List<TrendModel>> trendsStream({int limit = 50}) {
    return _db
        .collection('trends')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map(
            (d) => TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id),
          )
          .toList();
    });
  }

  /// Fetch all trends from all categories (mixed feed)
  Future<List<TrendModel>> fetchAllTrends({int limit = 50}) async {
    try {
      // To avoid the feed being dominated by a single category (e.g., many stocks)
      // fetch a balanced set from each category, shuffle each category, then
      // interleave them round-robin. This produces a mixed feed with better
      // distribution across categories.
      final perCategory = (limit / 3).ceil();

      final results = await Future.wait([
        _db
            .collection('trends')
            .where('category', isEqualTo: 'youtube')
            .orderBy('date', descending: true)
            .limit(perCategory)
            .get(),
        _db
            .collection('trends')
            .where('category', isEqualTo: 'stock')
            .orderBy('date', descending: true)
            .limit(perCategory)
            .get(),
        _db
            .collection('trends')
            .where('category', isEqualTo: 'political')
            .orderBy('date', descending: true)
            .limit(perCategory)
            .get(),
      ]);

      final lists = results.map((snap) {
        return snap.docs
            .map((d) =>
                TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList();
      }).toList();

      // Shuffle within each category to add randomness
      for (final l in lists) {
        l.shuffle();
      }

      // Interleave round-robin with de-duplication and avoiding immediate repeats
      final merged = <TrendModel>[];
      final seenIds = <String>{};
      var index = 0;
      while (merged.length < limit) {
        var added = false;
        for (final l in lists) {
          if (index < l.length) {
            final candidate = l[index];

            // Skip if we've already added this exact item
            if (candidate.id.isNotEmpty && seenIds.contains(candidate.id)) {
              continue;
            }

            // Avoid adding same item consecutively
            if (merged.isNotEmpty && merged.last.id == candidate.id) {
              // Try to find a different item later in this list
              TrendModel? alternative;
              for (var j = index + 1; j < l.length; j++) {
                final alt = l[j];
                if (!seenIds.contains(alt.id) &&
                    (merged.isEmpty || merged.last.id != alt.id)) {
                  alternative = alt;
                  // swap positions so future interleaving keeps order
                  l[j] = candidate;
                  break;
                }
              }
              if (alternative != null) {
                merged.add(alternative);
                if (alternative.id.isNotEmpty) seenIds.add(alternative.id);
                if (merged.length >= limit) break;
                added = true;
              }
              // if no alternative, skip this candidate for now
              continue;
            }

            // Normal add
            merged.add(candidate);
            if (candidate.id.isNotEmpty) seenIds.add(candidate.id);
            if (merged.length >= limit) break;
            added = true;
          }
        }
        if (!added) break; // no more items
        index += 1;
      }

      // Final safety: remove any accidental duplicates keeping first occurrence
      final unique = <String>{};
      final finalList = <TrendModel>[];
      for (final t in merged) {
        if (t.id.isEmpty) {
          finalList.add(t);
        } else if (!unique.contains(t.id)) {
          unique.add(t.id);
          finalList.add(t);
        }
      }

      return finalList;
    } catch (e, st) {
      // ignore: avoid_print
      print('TrendRepository.fetchAllTrends error: $e\n$st');
      return Future.error(e);
    }
  }

  // Fetch a single trend by its ID
  Future<TrendModel?> getTrendById(String id) async {
    final doc = await _db.collection('trends').doc(id).get();
    if (!doc.exists) return null;

    return TrendModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Fetch based on category (political, youtube, stock)
  Future<List<TrendModel>> fetchTrendsByCategory(String category) async {
    try {
      final q = await _db
          .collection('trends')
          .where('category', isEqualTo: category)
          .orderBy('date', descending: true)
          .get();

      return q.docs
          .map(
              (d) => TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    } catch (e, st) {
      // Surface Firestore errors instead of silently returning an empty list.
      // This helps the UI show the error (Firestore often provides an index
      // creation link when a composite index is required).
      // ignore: avoid_print
      print('TrendRepository.fetchTrendsByCategory error: $e\n$st');
      return Future.error(e);
    }
  }

  // Shortcut methods for UI
  Future<List<TrendModel>> fetchPoliticalTrends() =>
      fetchTrendsByCategory('political');

  Future<List<TrendModel>> fetchYoutubeTrends() =>
      fetchTrendsByCategory('youtube');

  Future<List<TrendModel>> fetchStockTrends() => fetchTrendsByCategory('stock');

  // Stream for category-specific real-time updates
  Stream<List<TrendModel>> trendsStreamByCategory(String category) {
    return _db
        .collection('trends')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map(
            (d) => TrendModel.fromMap(d.data() as Map<String, dynamic>, d.id),
          )
          .toList();
    });
  }
}
