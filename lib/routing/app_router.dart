// lib/routing/app_router.dart
import 'package:flutter/material.dart';
import 'route_names.dart';

// Use package imports to avoid relative path mistakes
import 'package:synq/features/auth/splash_screen.dart';
import 'package:synq/features/auth/login_screen.dart';
import 'package:synq/features/auth/register_screen.dart';
import 'package:synq/features/auth/forgot_password_screen.dart';
import 'package:synq/features/home/home_screen.dart';
import 'package:synq/features/trends/youtube_trends_screen.dart';
import 'package:synq/features/trends/political_trends_screen.dart';
import 'package:synq/features/trends/stock_trends_screen.dart';
import 'package:synq/features/trends/trend_sync_screen.dart';
import 'package:synq/features/reports/reports_screen.dart';
import 'package:synq/features/trends/trend_search_screen.dart';
import 'package:synq/features/admin/admin_dashboard.dart';
import 'package:synq/features/admin/user_management.dart';

/// Central routing configuration managing navigation throughout the Synq app.
///
/// Defines all named routes and route generation logic. Handles page transitions,
/// deep linking, and route parameters. Manages both authenticated and unauthenticated
/// navigation flows based on user authentication state.
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.youtubeTrends:
        return MaterialPageRoute(builder: (_) => const YouTubeTrendsScreen());
      case RouteNames.politicalTrends:
        return MaterialPageRoute(builder: (_) => const PoliticalTrendsScreen());
      case RouteNames.stockTrends:
        return MaterialPageRoute(builder: (_) => const StockTrendsScreen());
      case RouteNames.trendSync:
        return MaterialPageRoute(builder: (_) => const TrendSyncScreen());
      case RouteNames.trendSearch:
        return MaterialPageRoute(builder: (_) => const TrendSearchScreen());
      case RouteNames.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case RouteNames.userManagement:
        return MaterialPageRoute(builder: (_) => const UserManagementScreen());
      case RouteNames.adminReports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case RouteNames.dailyReports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case RouteNames.weeklyReports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case RouteNames.monthlyReports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
