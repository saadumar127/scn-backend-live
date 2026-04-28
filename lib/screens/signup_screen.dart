import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/gradient_button.dart';
import '../widgets/modern_textfield.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _signup() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.instance.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main-navigation');
    } catch (e) {
      _showMessage('Signup failed: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _hero(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 30 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D006B), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 90),
          const SizedBox(height: 16),
          Text(
            'Start Your Career Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 30 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Create your account and explore smart career paths.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _signupCard() {
    return GlassCard(
      child: Column(
        children: [
          const Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          ModernTextField(
            controller: nameController,
            hint: 'Full Name',
          ),
          const SizedBox(height: 12),

          ModernTextField(
            controller: emailController,
            hint: 'Email',
          ),
          const SizedBox(height: 12),

          ModernTextField(
            controller: passwordController,
            hint: 'Password',
            obscure: true,
          ),
          const SizedBox(height: 20),

          isLoading
              ? const CircularProgressIndicator()
              : GradientButton(
            text: 'Sign Up',
            onPressed: _signup,
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFC084FC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: isDesktop
                  ? Row(
                children: [
                  Expanded(child: _hero(true)),
                  const SizedBox(width: 20),
                  Expanded(child: _signupCard()),
                ],
              )
                  : Column(
                children: [
                  _hero(false),
                  const SizedBox(height: 20),
                  _signupCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}