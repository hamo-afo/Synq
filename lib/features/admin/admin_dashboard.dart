import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routing/route_names.dart';
import '../../features/providers/auth_provider.dart';
import '../../core/services/admin_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, RouteNames.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Sync Trends (YouTube / Stock / Political)'),
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.trendSync),
            ),
            const SizedBox(height: 12),
            // Temporary founder-only helper to set isAdmin on current user doc
            Builder(builder: (ctx) {
              final authProv = Provider.of<AuthProvider>(ctx, listen: false);
              final user = authProv.user;
              if (user != null &&
                  user.email == 'hamoafo@gmail.com' &&
                  !user.isAdmin) {
                return ElevatedButton.icon(
                  icon: const Icon(Icons.security_update_good),
                  label: const Text('Claim Admin (founder)'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () async {
                    try {
                      final svc = AdminService();
                      await svc.setAdmin(user.uid, true);
                      await authProv.loadCurrentUser();
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('You are now an admin')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('Failed to claim admin: $e')),
                      );
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('User Management'),
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.userManagement),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Reports'),
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.adminReports),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Purge Old Trends (manual)')),
                Chip(label: Text('Rebuild Indexes (console)')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Tips', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Use User Management to promote/demote admins, ban users, delete user documents, and purge old trends.'),
          ],
        ),
      ),
    );
  }
}
