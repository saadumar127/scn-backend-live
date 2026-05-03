import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/gradient_button.dart';
import '../widgets/modern_textfield.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showMessage('Please enter email and password');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.instance.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main-navigation');
    } catch (e) {
      _showMessage('Invalid email or password. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => isLoading = true);

    try {
      final user = await AuthService.instance.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/main-navigation');
      }
    } catch (e) {
      _showMessage('Google sign-in failed: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Widget _aiHero(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 38 : 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B063A),
            Color(0xFF4C1D95),
            Color(0xFF9333EA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF8B5CF6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9333EA).withOpacity(0.35),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              'AI Career Guidance',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 46),

          Container(
            height: isDesktop ? 190 : 150,
            width: isDesktop ? 190 : 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.35),
                  blurRadius: 45,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/scn_robot.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 90,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 42),

          Text(
            'Lets Discover your best career\npath with AI',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 38 : 28,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Personalized suggestions, smart quiz, AI advisor, roadmap and history tracking for students.',
            style: TextStyle(
              color: Color(0xFFEDE9FE),
              height: 1.6,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginCard() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Login to continue your SCN journey',
              style: TextStyle(
                color: Color(0xFFEDE9FE),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            ModernTextField(
              controller: emailController,
              hint: 'Email address',
            ),

            const SizedBox(height: 16),

            ModernTextField(
              controller: passwordController,
              hint: 'Password',
              obscure: true,
            ),

            const SizedBox(height: 24),

            isLoading
                ? const CircularProgressIndicator(
              color: Color(0xFFC084FC),
            )
                : GradientButton(
              text: 'Log In',
              onPressed: _login,
            ),

            const SizedBox(height: 18),

            InkWell(
              onTap: isLoading ? null : _googleLogin,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D164F),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Color(0xFFEDE9FE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFFD8B4FE),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFF0A001F),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: isDesktop
                  ? Row(
                children: [
                  Expanded(child: _aiHero(true)),
                  const SizedBox(width: 28),
                  Expanded(child: _loginCard()),
                ],
              )
                  : Column(
                children: [
                  _aiHero(false),
                  const SizedBox(height: 22),
                  _loginCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}