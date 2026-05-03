import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  String _firstLetter(String name, String email) {
    if (name.trim().isNotEmpty) return name.trim()[0].toUpperCase();
    if (email.trim().isNotEmpty) return email.trim()[0].toUpperCase();
    return 'S';
  }

  // 🔥 FIXED INFO CARD (Readable)
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF2D164F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFFEDE9FE)),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 LABEL
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFD8B4FE),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 🔥 VALUE
                  Text(
                    value.isEmpty ? 'Not added yet' : value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 FIXED PROGRESS CARD
  Widget _progressCard(bool profileComplete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Strength',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              profileComplete ? '95% Complete' : '45% Complete',
              style: const TextStyle(
                color: Color(0xFFEDE9FE),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: profileComplete ? 0.95 : 0.45,
                minHeight: 8,
                color: const Color(0xFFC084FC),
                backgroundColor: const Color(0xFF2D164F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: FirestoreService.instance.getUserProfileStream(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? {};

            final name =
            (data['name'] ?? firebaseUser?.displayName ?? 'Student');
            final email = (data['email'] ?? firebaseUser?.email ?? '');

            final level = (data['educationLevel'] ?? '');
            final field = (data['selectedField'] ?? '');
            final percentage = (data['percentage'] ?? '');

            final profileComplete =
                level != '' && field != '' && percentage != '';

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [

                // 🔥 HEADER
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2D006B),
                        Color(0xFF7C3AED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        child: Text(
                          _firstLetter(name, email),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(color: Color(0xFFEDE9FE)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _progressCard(profileComplete),

                _infoCard(
                  icon: Icons.school,
                  title: 'Education Level',
                  value: level,
                ),

                _infoCard(
                  icon: Icons.category,
                  title: 'Selected Field',
                  value: field,
                ),

                _infoCard(
                  icon: Icons.percent,
                  title: 'Percentage',
                  value: '$percentage%',
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9333EA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () => _logout(context),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}