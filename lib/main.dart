// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'routing/app_router.dart';
import 'routing/route_names.dart';
import 'features/providers/auth_provider.dart';
import 'features/auth/splash_screen.dart';
import 'theme/theme.dart'; // your theme class
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SynqApp());
}

class SynqApp extends StatelessWidget {
  const SynqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        title: 'Synq',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // light theme
        darkTheme: AppTheme.darkTheme, // dark theme
        themeMode: ThemeMode.dark, // force dark theme throughout app
        initialRoute: RouteNames.splash, // starting screen
        onGenerateRoute: AppRouter.generateRoute, // handles all routes
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
