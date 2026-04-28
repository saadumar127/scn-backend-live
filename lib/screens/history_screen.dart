import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../theme/scn_modern_theme.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history';

  const HistoryScreen({super.key});

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: SCNTheme.primary),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: SCNTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: SCNTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: SCNTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: SCNTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SCNTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: SCNTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.instance.getQuizHistoryStream(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return _emptyState(
            'No Quiz History',
            'Your completed quiz results will appear here.',
            Icons.quiz_rounded,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return _historyCard(
              title: (item['recommendedField'] ?? 'Quiz Result').toString(),
              subtitle:
              '${item['educationLevel'] ?? 'Unknown'} • ${item['selectedField'] ?? 'General'}',
              icon: Icons.quiz_rounded,
            );
          },
        );
      },
    );
  }

  Widget _chatTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.instance.getChatHistoryStream(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return _emptyState(
            'No Chat History',
            'Your AI chatbot conversations will appear here.',
            Icons.chat_bubble_rounded,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return _historyCard(
              title: (item['userMessage'] ?? 'Chat Message').toString(),
              subtitle: (item['botReply'] ?? '').toString(),
              icon: Icons.chat_bubble_rounded,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: SCNTheme.bgLight,
        appBar: AppBar(
          title: const Text('History'),
          backgroundColor: SCNTheme.bgLight,
          elevation: 0,
          bottom: const TabBar(
            labelColor: SCNTheme.primary,
            unselectedLabelColor: SCNTheme.textSecondary,
            tabs: [
              Tab(text: 'Quiz'),
              Tab(text: 'Chat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _quizTab(),
            _chatTab(),
          ],
        ),
      ),
    );
  }
}