import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'home_shell_screen.dart';

class AuthGate extends StatelessWidget {
  static const String routeName = '/auth-gate';

  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF070018),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC084FC),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomeShellScreen();
        }

        return const LoginScreen();
      },
    );
  }
}