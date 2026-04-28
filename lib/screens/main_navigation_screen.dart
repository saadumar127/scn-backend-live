import 'package:flutter/material.dart';
import 'home_shell_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'chatbot_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/main-navigation';

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeShellScreen(),
    ChatbotScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: MediaQuery.of(context).size.width >= 950
          ? null
          : Container(
        decoration: const BoxDecoration(
          color: Color(0xFF12002B),
          border: Border(
            top: BorderSide(color: Color(0xFF3B0764), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: const Color(0xFF12002B),
          selectedItemColor: const Color(0xFFC084FC),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_rounded),
              label: "Chatbot",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );

  }
}