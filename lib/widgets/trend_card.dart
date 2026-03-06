import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../data/models/trend_model.dart';
import '../features/trends/trend_detail_screen.dart';
import '../features/providers/auth_provider.dart' as app_auth;
import 'package:url_launcher/url_launcher.dart';

/// Reusable widget displaying a single trend card with engagement features.
///
/// Shows trend information (title, summary, source), engagement metrics (likes/comments),
/// and action buttons. Users can like/unlike trends, view comments, and navigate to
/// detailed views. Handles real-time updates of engagement data from Firestore.
class TrendCard extends StatefulWidget {
  final TrendModel trend;

  const TrendCard({Key? key, required this.trend}) : super(key: key);

  @override
  State<TrendCard> createState() => _TrendCardState();
}

class _TrendCardState extends State<TrendCard>
    with AutomaticKeepAliveClientMixin {
  late TrendModel _trend;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late String _currentUserId;
  String _currentUserName = 'Anonymous';

  @override
  void initState() {
    super.initState();
    _trend = widget.trend;
    final fbUser = FirebaseAuth.instance.currentUser;
    _currentUserId = fbUser?.uid ?? 'anonymous_user';

    try {
      final authProvider =
          Provider.of<app_auth.AuthProvider>(context, listen: false);
      _currentUserName = (authProvider.user?.name?.trim().isNotEmpty ?? false)
          ? authProvider.user!.name.trim()
          : (fbUser?.displayName?.trim().isNotEmpty ?? false)
              ? fbUser!.displayName!.trim()
              : 'User';
    } catch (_) {
      // Provider not found; keep default anonymous name.
    }
  }

  Future<void> _toggleLike() async {
    try {
      final newLikedBy = List<String>.from(_trend.likedBy);

      if (newLikedBy.contains(_currentUserId)) {
        newLikedBy.remove(_currentUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('👎 You unliked this post'),
              duration: Duration(milliseconds: 800),
            ),
          );
        }
      } else {
        newLikedBy.add(_currentUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❤️ You liked this post!'),
              duration: Duration(milliseconds: 800),
            ),
          );
        }
      }

      final newTrend = TrendModel(
        id: _trend.id,
        title: _trend.title,
        category: _trend.category,
        summary: _trend.summary,
        content: _trend.content,
        date: _trend.date,
        source: _trend.source,
        fetchedAt: _trend.fetchedAt,
        extras: _trend.extras,
        likes: newLikedBy.length,
        likedBy: newLikedBy,
        comments: _trend.comments,
      );

      await _db
          .collection('trends')
          .doc(_trend.id)
          .set(newTrend.toMap(), SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _trend = newTrend;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error toggling like: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showCommentDialog() {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write your comment...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (commentController.text.isNotEmpty) {
                await _addComment(commentController.text);
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment added!')),
                  );
                }
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Future<void> _addComment(String text) async {
    try {
      final newComment = {
        'text': text,
        'author': _currentUserName,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final newComments = List<Map<String, dynamic>>.from(_trend.comments);
      newComments.add(newComment);

      final newTrend = TrendModel(
        id: _trend.id,
        title: _trend.title,
        category: _trend.category,
        summary: _trend.summary,
        content: _trend.content,
        date: _trend.date,
        source: _trend.source,
        fetchedAt: _trend.fetchedAt,
        extras: _trend.extras,
        likes: _trend.likes,
        likedBy: _trend.likedBy,
        comments: newComments,
      );

      await _db
          .collection('trends')
          .doc(_trend.id)
          .set(newTrend.toMap(), SetOptions(merge: true));

      setState(() {
        _trend = newTrend;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error adding comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final imageUrl = _getImageUrl();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final isLiked = _trend.likedBy.contains(_currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or Video Thumbnail
          if (hasImage)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[300],
              ),
              child: _buildMediaWidget(imageUrl),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(),
                  size: 60,
                  color: Colors.grey[600],
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _trend.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  _trend.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Summary/Description
                Text(
                  _trend.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                // Footer with source and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _trend.source ?? 'Unknown Source',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      _formatDate(_trend.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Like and Comment buttons
                Row(
                  children: [
                    // Like button
                    Expanded(
                      child: isLiked
                          ? ElevatedButton.icon(
                              onPressed: _toggleLike,
                              icon: const Icon(Icons.favorite),
                              label: Text('Liked (${_trend.likes})'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                              ),
                            )
                          : OutlinedButton.icon(
                              onPressed: _toggleLike,
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Like (${_trend.likes})',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    // Comment button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openCommentsSheet,
                        icon: const Icon(Icons.comment, color: Colors.blue),
                        label: Text(
                          'Comment (${_trend.comments.length})',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCommentsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final comments = List<Map<String, dynamic>>.from(_trend.comments);
        comments.sort((a, b) {
          final at = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now();
          final bt = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime.now();
          return at.compareTo(bt);
        });

        final controller = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.6,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(
                          child: Text('No comments yet. Be the first!'),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            final author =
                                (c['author'] ?? 'Anonymous').toString().trim();
                            final text = (c['text'] ?? '').toString().trim();
                            final ts = DateTime.tryParse(c['timestamp'] ?? '');
                            final timeStr = ts != null ? _formatDate(ts) : '';
                            return ListTile(
                              dense: true,
                              title: Text(text),
                              subtitle: Text(
                                author.isEmpty ? timeStr : '$author · $timeStr',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () async {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;
                          await _addComment(text);
                          controller.clear();
                          if (mounted) {
                            Navigator.of(ctx).pop();
                            _openCommentsSheet();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get image URL from extras with fallback handling
  String? _getImageUrl() {
    if (widget.trend.extras?.containsKey('thumbnailUrl') ?? false) {
      final url = widget.trend.extras?['thumbnailUrl'] as String?;
      if (url != null && url.isNotEmpty) return url;
    }
    if (widget.trend.extras?.containsKey('imageUrl') ?? false) {
      final url = widget.trend.extras?['imageUrl'] as String?;
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  /// Build media widget with better error handling
  Widget _buildMediaWidget(String imageUrl) {
    final videoUrl = widget.trend.extras?['videoUrl'] as String?;
    final symbol = widget.trend.extras?['symbol'] as String?;

    return InkWell(
      onTap: () async {
        if (videoUrl != null && videoUrl.isNotEmpty) {
          final uri = Uri.parse(videoUrl);
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (e) {
            // ignore: avoid_print
            print('Could not launch $videoUrl: $e');
          }
        } else {
          // fallback: open detail screen
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TrendDetailScreen(trend: widget.trend)),
            );
          }
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            cacheHeight: 200,
            cacheWidth: 400,
            errorBuilder: (_, __, ___) {
              // Primary image failed; render an in-app symbol placeholder
              if (symbol != null && symbol.isNotEmpty) {
                return _buildSymbolPlaceholder(symbol);
              }
              return _buildImageUnavailable();
            },
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          if (videoUrl != null && videoUrl.isNotEmpty)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageUnavailable() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(),
              size: 50,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolPlaceholder(String symbol) {
    // Render a local colored box with the symbol text centered.
    return Container(
      color: const Color(0xFF4B7F6A),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  /// Get icon based on category
  IconData _getCategoryIcon() {
    switch (_trend.category.toLowerCase()) {
      case 'youtube':
        return Icons.video_library;
      case 'stock':
        return Icons.trending_up;
      case 'political':
        return Icons.newspaper;
      default:
        return Icons.trending_up;
    }
  }

  /// Get color based on category
  Color _getCategoryColor() {
    switch (_trend.category.toLowerCase()) {
      case 'youtube':
        return Colors.red;
      case 'stock':
        return Colors.green;
      case 'political':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
