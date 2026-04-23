// ============================================================
// FILE: state/auth_state.dart
// PURPOSE: Simple local authentication state management
// CONCEPT: OOP, Variables, if-else, ChangeNotifier
// ============================================================

import 'package:flutter/foundation.dart';

/// AuthState manages the login session for the entire app.
/// Extends ChangeNotifier so the UI rebuilds when state changes.
class AuthState extends ChangeNotifier {
  // ---- Hardcoded credentials ----
  static const String _validUsername = 'admin';
  static const String _validPassword = '1234';

  // ---- State Variables ----
  bool _isLoggedIn = false;   // Is the user currently logged in?
  String _loggedInUser = '';  // Store the logged-in username

  // ---- Public Getters ----
  bool get isLoggedIn => _isLoggedIn;
  String get loggedInUser => _loggedInUser;

  // ----------------------------------------------------------------
  // METHOD: login()
  // Validates credentials and returns true/false
  // CONCEPT: if-else conditional logic
  // ----------------------------------------------------------------
  bool login(String username, String password) {
    // Trim whitespace from inputs before checking
    final String trimmedUsername = username.trim();
    final String trimmedPassword = password.trim();

    // Check credentials using if-else
    if (trimmedUsername == _validUsername &&
        trimmedPassword == _validPassword) {
      // ✅ Credentials match — log the user in
      _isLoggedIn = true;
      _loggedInUser = trimmedUsername;
      notifyListeners(); // Notify widgets to rebuild
      return true;
    } else {
      // ❌ Wrong credentials
      return false;
    }
  }

  // ----------------------------------------------------------------
  // METHOD: logout()
  // Clears the session and returns user to login screen
  // ----------------------------------------------------------------
  void logout() {
    _isLoggedIn = false;
    _loggedInUser = '';
    notifyListeners(); // Notify widgets to rebuild
  }
}