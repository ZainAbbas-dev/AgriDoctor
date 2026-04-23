// ============================================================
// FILE: screens/login_screen.dart
// PURPOSE: Premium login UI with animations and validation
// CONCEPT: StatefulWidget, TextEditingController, if-else, OOP
// ============================================================

import 'package:flutter/material.dart';
import '../state/auth_state.dart';
import 'home_screen.dart';

/// LoginScreen — Premium entry gate for the Agri-Doctor app.
/// Uses StatefulWidget to manage form inputs, errors, and loading state.
class LoginScreen extends StatefulWidget {
  // Receives the AuthState object from main.dart
  final AuthState authState;

  const LoginScreen({super.key, required this.authState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ---- Controllers: read text field values ----
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ---- Form key for validation ----
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ---- State Variables ----
  bool _isPasswordVisible = false; // Toggle password show/hide
  bool _isLoading = false;         // Show spinner while "logging in"
  String _errorMessage = '';       // Error text shown below the button

  // ---- Animation controller for card entrance ----
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ----------------------------------------------------------------
  // LIFECYCLE: Initialize animations
  // ----------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    // Setup animation controller (600ms duration)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Fade in from 0 → 1
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    // Slide up from bottom
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation when screen loads
    _animController.forward();
  }

  // ----------------------------------------------------------------
  // LIFECYCLE: Dispose controllers to avoid memory leaks
  // ----------------------------------------------------------------
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------
  // METHOD: Handle login button press
  // CONCEPT: if-else, async/await, setState
  // ----------------------------------------------------------------
  Future<void> _handleLogin() async {
    // Clear any previous error
    setState(() => _errorMessage = '');

    // Validate form fields (not empty)
    if (!_formKey.currentState!.validate()) return;

    // Show loading spinner
    setState(() => _isLoading = true);

    // Simulate a brief network/processing delay for realism
    await Future.delayed(const Duration(milliseconds: 1200));

    // Call login() on AuthState — returns true/false
    final bool success = widget.authState.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // ✅ Login successful — navigate to HomeScreen
      // pushReplacement prevents going back to login with back button
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            // Smooth fade transition into home screen
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      // ❌ Login failed — show error, stop spinner
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid username or password. Please try again.';
      });
    }
  }

  // ----------------------------------------------------------------
  // BUILD METHOD
  // ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar on login screen — full immersive gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // ---- Full screen gradient background ----
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1B5E20), // Very dark green (top)
              Color(0xFF2E7D32), // Dark green
              Color(0xFF388E3C), // Mid green
              Color(0xFF66BB6A), // Light green (bottom)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ---- Top decorative element ----
                  _buildTopDecoration(),

                  const SizedBox(height: 30),

                  // ---- Animated Login Card ----
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: _buildLoginCard(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---- Bottom hint text ----
                  _buildBottomHint(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: Top logo + title above the card
  // ----------------------------------------------------------------
  Widget _buildTopDecoration() {
    return Column(
      children: [
        // Glowing icon container
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.eco,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Agri-Doctor',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Smart Plant Disease Detection',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: The main white login card
  // ----------------------------------------------------------------
  Widget _buildLoginCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Card Title ----
              const Center(
                child: Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---- Username Field ----
              _buildFieldLabel('Username'),
              const SizedBox(height: 8),
              _buildUsernameField(),

              const SizedBox(height: 20),

              // ---- Password Field ----
              _buildFieldLabel('Password'),
              const SizedBox(height: 8),
              _buildPasswordField(),

              const SizedBox(height: 10),

              // ---- Error Message (shown only on failure) ----
              if (_errorMessage.isNotEmpty) _buildErrorMessage(),

              const SizedBox(height: 24),

              // ---- Login Button ----
              _buildLoginButton(),

              const SizedBox(height: 16),

              // ---- Demo credentials hint ----
              _buildCredentialsHint(),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Field label text ----
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E7D32),
        letterSpacing: 0.3,
      ),
    );
  }

  // ---- Username text field ----
  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
      decoration: _inputDecoration(
        hint: 'Enter your username',
        icon: Icons.person_outline,
      ),
      // Validation: must not be empty
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  // ---- Password text field with show/hide toggle ----
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible, // Toggle visibility
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      style: const TextStyle(fontSize: 15, color: Color(0xFF1B5E20)),
      decoration: _inputDecoration(
        hint: 'Enter your password',
        icon: Icons.lock_outline,
      ).copyWith(
        // Suffix: eye icon toggle button
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF2E7D32),
            size: 20,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ),
      // Validation: must not be empty
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  // ---- Shared input decoration style ----
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
      filled: true,
      fillColor: const Color(0xFFF1F8E9),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF2E7D32),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: const TextStyle(fontSize: 11.5),
    );
  }

  // ---- Animated error message ----
  Widget _buildErrorMessage() {
    return AnimatedOpacity(
      opacity: _errorMessage.isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Gradient login button ----
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, size: 20),
              SizedBox(width: 8),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Demo credentials hint at bottom of card ----
  Widget _buildCredentialsHint() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 16, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                children: const [
                  TextSpan(text: 'Demo: '),
                  TextSpan(
                    text: 'admin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  TextSpan(text: ' / '),
                  TextSpan(
                    text: '1234',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Bottom hint text below the card ----
  Widget _buildBottomHint() {
    return Text(
      '🌾 Protecting crops, empowering farmers',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.75),
        fontSize: 13,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}