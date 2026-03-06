import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/admin_service.dart';
import '../../data/models/user_model.dart';
import '../../features/providers/auth_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AdminService _admin = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _admin.fetchUsers(limit: 500),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? [];
          final auth = Provider.of<AuthProvider>(context, listen: false);
          final currentUser = auth.user;
          if (currentUser == null || !currentUser.isAdmin) {
            return const Center(
                child: Text('Not authorized. Admin access required.'));
          }
          if (docs.isEmpty) return const Center(child: Text('No users found'));

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();
              final model = UserModel.fromMap(data, d.id);
              final isAdmin = data['isAdmin'] as bool? ?? false;
              final banned = data['banned'] as bool? ?? false;

              return ListTile(
                title: Text(model.name.isNotEmpty ? model.name : model.email),
                subtitle: Text(model.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                          isAdmin ? Icons.admin_panel_settings : Icons.person),
                      color: isAdmin ? Colors.orange : null,
                      tooltip: isAdmin ? 'Revoke admin' : 'Make admin',
                      onPressed: () async {
                        try {
                          await _admin.setAdmin(d.id, !isAdmin);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(isAdmin
                                  ? 'Admin revoked'
                                  : 'Admin granted')));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to update admin: $e')));
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(banned ? Icons.block : Icons.check_circle),
                      color: banned ? Colors.red : Colors.green,
                      tooltip: banned ? 'Unban user' : 'Ban user',
                      onPressed: () async {
                        try {
                          await _admin.setBanned(d.id, !banned);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  !banned ? 'User banned' : 'User unbanned')));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to update ban: $e')));
                        }
                      },
                    ),
                    PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'delete') {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete user'),
                              content: const Text(
                                  'Delete user document? This cannot be undone.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete')),
                              ],
                            ),
                          );
                          if (ok == true) {
                            try {
                              await _admin.deleteUser(d.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('User document deleted')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to delete user: $e')));
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: 'delete', child: Text('Delete user doc')),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.delete_forever),
        label: const Text('Purge trends > 90d'),
        backgroundColor: Colors.red,
        onPressed: () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Purge old trends'),
              content: const Text(
                  'Delete trends older than 90 days? This will remove many documents.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Purge')),
              ],
            ),
          );
          if (ok == true) {
            final deleted = await _admin.purgeOldTrends(days: 90);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted $deleted trends')));
          }
        },
      ),
    );
  }
}
