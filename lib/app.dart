import 'package:flutter/material.dart';
import 'theme/scn_modern_theme.dart'; // 👈 NEW THEME

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/select_level_screen.dart';
import 'screens/select_field_screen.dart';
import 'screens/select_program_screen.dart';
import 'screens/student_details_screen.dart';
import 'screens/interest_choice_screen.dart';
import 'screens/suggestions_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/roadmap_screen.dart';
import 'screens/home_shell_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/history_screen.dart';
import 'screens/edit_profile_screen.dart';

class SmartCareerNavigatorApp extends StatelessWidget {
  const SmartCareerNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Career Navigator',
      debugShowCheckedModeBanner: false,

      // 🔥 ONLY THIS CHANGE
      theme: SCNTheme.lightTheme,

      initialRoute: SplashScreen.routeName,

      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        SelectLevelScreen.routeName: (context) => const SelectLevelScreen(),
        SelectFieldScreen.routeName: (context) => const SelectFieldScreen(),
        SelectProgramScreen.routeName: (context) => const SelectProgramScreen(),
        StudentDetailsScreen.routeName: (context) =>
        const StudentDetailsScreen(),
        InterestChoiceScreen.routeName: (context) =>
        const InterestChoiceScreen(),
        SuggestionsScreen.routeName: (context) => const SuggestionsScreen(),
        ChatbotScreen.routeName: (context) => const ChatbotScreen(),
        QuizScreen.routeName: (context) => const QuizScreen(),
        QuizResultScreen.routeName: (context) => const QuizResultScreen(),
        RoadmapScreen.routeName: (context) => const RoadmapScreen(),
        HomeShellScreen.routeName: (context) => const HomeShellScreen(),
        MainNavigationScreen.routeName: (context) =>
        const MainNavigationScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        HistoryScreen.routeName: (context) => const HistoryScreen(),
        EditProfileScreen.routeName: (context) =>
        const EditProfileScreen(),


        '/home-shell': (context) => const MainNavigationScreen(),
      },
    );
  }
}