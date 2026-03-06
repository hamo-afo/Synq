import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

/// ReportRepository
///
/// Provides a collection of aggregation helpers for building admin reports
/// (daily / weekly / monthly counts, top trends by likes, engagement metrics,
/// top stock symbols etc). These are implemented client-side by fetching the
/// relevant documents and aggregating locally because Firestore lacks flexible
/// server-side aggregations in many projects.
class ReportRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _trends;

  ReportRepository()
      : _trends = FirebaseFirestore.instance.collection('trends');

  /// Stream reports from a specified Firestore path
  Stream<List<ReportModel>> reportsStream(String path) {
    return _db.collection(path).snapshots().map((snap) {
      return snap.docs
          .map((doc) =>
              ReportModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Helper to clamp the number of documents fetched to avoid huge reads.
  // Increase if you know your dataset is small or you have paging.
  static const int _defaultLimit = 2000;

  /// Counts posts in each category between [from] and [to]. If both are null,
  /// counts the most recent [_defaultLimit] documents grouped by category.
  Future<Map<String, int>> countsByCategory(
      {DateTime? from, DateTime? to}) async {
    Query<Map<String, dynamic>> q =
        _trends.orderBy('date', descending: true).limit(_defaultLimit);

    if (from != null)
      q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    if (to != null)
      q = q.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));

    final snap = await q.get();
    final counts = <String, int>{};
    for (final doc in snap.docs) {
      final cat = (doc.data()['category'] ?? 'unknown').toString();
      counts[cat] = (counts[cat] ?? 0) + 1;
    }
    return counts;
  }

  /// Returns daily counts for the last [days] days (including today).
  /// Result is a list of maps: { 'date': DateTime, 'count': int }
  Future<List<Map<String, dynamic>>> dailyCounts(int days) async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));

    final q = _trends
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('date', descending: true);
    final snap = await q.get();

    final counts = <String, int>{};
    for (final d in snap.docs) {
      final dateField = d.data()['date'];
      DateTime date;
      if (dateField is Timestamp)
        date = dateField.toDate();
      else
        date = DateTime.now();
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final out = <Map<String, dynamic>>[];
    for (var i = 0; i < days; i++) {
      final d =
          DateTime(from.year, from.month, from.day).add(Duration(days: i));
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      out.add({'date': d, 'count': counts[key] ?? 0});
    }
    return out;
  }

  /// Weekly counts for the last [weeks] weeks. Each week starts on Monday.
  /// Returns list of { 'weekStart': DateTime, 'count': int }
  Future<List<Map<String, dynamic>>> weeklyCounts(int weeks) async {
    final now = DateTime.now();
    // find Monday of this week
    final todayMonday = now.subtract(Duration(days: now.weekday - 1));
    final from = DateTime(todayMonday.year, todayMonday.month, todayMonday.day)
        .subtract(Duration(days: 7 * (weeks - 1)));

    final q =
        _trends.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    final snap = await q.get();

    final counts = <String, int>{};
    for (final d in snap.docs) {
      final dateField = d.data()['date'];
      DateTime date =
          dateField is Timestamp ? dateField.toDate() : DateTime.now();
      final monday = date.subtract(Duration(days: date.weekday - 1));
      final key =
          '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final out = <Map<String, dynamic>>[];
    for (var i = 0; i < weeks; i++) {
      final weekStart =
          DateTime(todayMonday.year, todayMonday.month, todayMonday.day)
              .subtract(Duration(days: 7 * (weeks - 1 - i)));
      final key =
          '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
      out.add({'weekStart': weekStart, 'count': counts[key] ?? 0});
    }
    return out;
  }

  /// Monthly counts for the last [months] months. Returns list of { 'month': DateTime(firstDay), 'count': int }
  Future<List<Map<String, dynamic>>> monthlyCounts(int months) async {
    final now = DateTime.now();
    final firstOfThisMonth = DateTime(now.year, now.month, 1);
    final from = DateTime(firstOfThisMonth.year, firstOfThisMonth.month, 1)
        .subtract(Duration(days: 30 * (months - 1)));

    final q =
        _trends.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    final snap = await q.get();

    final counts = <String, int>{};
    for (final d in snap.docs) {
      final dateField = d.data()['date'];
      final date = dateField is Timestamp ? dateField.toDate() : DateTime.now();
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final out = <Map<String, dynamic>>[];
    for (var i = 0; i < months; i++) {
      final m = DateTime(
          firstOfThisMonth.year, firstOfThisMonth.month - (months - 1 - i), 1);
      final key = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      out.add({'month': m, 'count': counts[key] ?? 0});
    }
    return out;
  }

  /// Returns top trends by likes in the specified time range.
  /// Each item: { 'id', 'title', 'category', 'likes', 'comments' }
  Future<List<Map<String, dynamic>>> topTrendsByLikes(int limit,
      {DateTime? from, DateTime? to}) async {
    Query<Map<String, dynamic>> q =
        _trends.orderBy('likes', descending: true).limit(limit);
    if (from != null)
      q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    if (to != null)
      q = q.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));

    final snap = await q.get();
    final out = <Map<String, dynamic>>[];
    for (final d in snap.docs) {
      final data = d.data();
      out.add({
        'id': d.id,
        'title': data['title'] ?? '',
        'category': data['category'] ?? '',
        'likes': data['likes'] ?? 0,
        'comments': (data['comments'] as List?)?.length ?? 0,
      });
    }
    return out;
  }

  /// Engagement metrics in a range: totalPosts, totalLikes, totalComments, avgLikesPerPost, avgCommentsPerPost, uniqueLikers
  Future<Map<String, dynamic>> engagementMetrics(
      {DateTime? from, DateTime? to}) async {
    Query<Map<String, dynamic>> q =
        _trends.orderBy('date', descending: true).limit(_defaultLimit);
    if (from != null)
      q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    if (to != null)
      q = q.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));

    final snap = await q.get();
    var totalPosts = 0;
    var totalLikes = 0;
    var totalComments = 0;
    final uniqueLikers = <String>{};

    for (final d in snap.docs) {
      totalPosts += 1;
      final data = d.data();
      totalLikes += (data['likes'] ?? 0) as int;
      final comments = (data['comments'] as List?) ?? [];
      totalComments += comments.length;
      final likedBy = (data['likedBy'] as List?) ?? [];
      for (final u in likedBy) {
        if (u != null) uniqueLikers.add(u.toString());
      }
    }

    final avgLikes = totalPosts > 0 ? totalLikes / totalPosts : 0.0;
    final avgComments = totalPosts > 0 ? totalComments / totalPosts : 0.0;

    return {
      'totalPosts': totalPosts,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'avgLikesPerPost': avgLikes,
      'avgCommentsPerPost': avgComments,
      'uniqueLikers': uniqueLikers.length,
    };
  }

  /// Top stock symbols by mention count in the given range.
  /// Returns list of { 'symbol', 'count' }
  Future<List<Map<String, dynamic>>> topStockSymbols(int limit,
      {DateTime? from, DateTime? to}) async {
    Query<Map<String, dynamic>> q =
        _trends.where('category', isEqualTo: 'stock');
    if (from != null)
      q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    if (to != null)
      q = q.where('date', isLessThanOrEqualTo: Timestamp.fromDate(to));
    q = q.orderBy('date', descending: true).limit(_defaultLimit);

    final snap = await q.get();
    final counts = <String, int>{};
    for (final d in snap.docs) {
      final extras = d.data()['extras'] as Map<String, dynamic>?;
      final symbol =
          extras?['symbol']?.toString() ?? d.data()['title']?.toString() ?? '';
      if (symbol.isEmpty) continue;
      counts[symbol] = (counts[symbol] ?? 0) + 1;
    }

    final list =
        counts.entries.map((e) => {'symbol': e.key, 'count': e.value}).toList();
    list.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    return list.take(limit).toList();
  }
}
