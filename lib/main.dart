// ============================================================
// FILE: main.dart
// PURPOSE: Entry point of the Agri-Doctor Flutter Application
// UPDATED: LoginScreen is now the initial route via AuthState
// ============================================================

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'state/auth_state.dart';

void main() {
  runApp(AgriDoctorApp());
}

/// Root application widget — sets up theme and initial screen.
/// Note: NOT const because AuthState() is a runtime object.
class AgriDoctorApp extends StatelessWidget {
  // Shared AuthState instance passed down to LoginScreen
  final AuthState _authState = AuthState();

  AgriDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri-Doctor',
      debugShowCheckedModeBanner: false,

      // ---- Global Green Theme ----
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF1F8E9),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.green.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ✅ Login screen is the entry point — passes authState
      home: LoginScreen(authState: _authState),
    );
  }
}