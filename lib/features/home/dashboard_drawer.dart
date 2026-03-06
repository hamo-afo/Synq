// lib/features/home/dashboard_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routing/route_names.dart';
import '../../features/providers/auth_provider.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Center(
                child: Text('Synq', style: TextStyle(fontSize: 24)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, RouteNames.home),
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('YouTube Trends'),
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.youtubeTrends),
            ),
            ListTile(
              leading: const Icon(Icons.poll),
              title: const Text('Political Trends'),
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.politicalTrends),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Stock Trends'),
              onTap: () => Navigator.pushNamed(context, RouteNames.stockTrends),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_sync),
              title: const Text('Trend Sync'),
              onTap: () => Navigator.pushNamed(context, RouteNames.trendSync),
            ),
            // Admin menu - visible only to admins
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              if (authProvider.user?.isAdmin ?? false) {
                return Column(
                  children: [
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        '🔐 ADMIN PANEL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings,
                          color: Colors.red),
                      title: const Text('Admin Dashboard'),
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.adminDashboard),
                    ),
                    ListTile(
                      leading: const Icon(Icons.sync, color: Colors.red),
                      title: const Text('Sync Trends'),
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.trendSync),
                    ),
                    ListTile(
                      leading: const Icon(Icons.people, color: Colors.red),
                      title: const Text('User Management'),
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.userManagement),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Reports'),
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.adminReports),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, RouteNames.appSettings),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                // Perform logout and navigate to login
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, RouteNames.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
