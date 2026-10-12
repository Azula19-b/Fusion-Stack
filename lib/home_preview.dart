import 'package:flutter/material.dart';
import 'package:frm_app/screens/home_screen.dart';

void main() {
  runApp(const HomePreviewApp());
}

/// Standalone entry point for reviewing Bahar's Home Screen without changing
/// the application's authentication flow in `main.dart`.
class HomePreviewApp extends StatelessWidget {
  const HomePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Refuge Ministries — Home Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: HomeColors.missionBlue,
          primary: HomeColors.deepBlue,
          surface: HomeColors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: HomeColors.white,
        textTheme: const TextTheme(
          displaySmall: TextStyle(fontSize: 38),
          headlineSmall: TextStyle(fontSize: 24),
          titleMedium: TextStyle(fontSize: 17),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 13),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: HomeColors.darkCharcoal,
          contentTextStyle: TextStyle(color: HomeColors.white),
          closeIconColor: HomeColors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
