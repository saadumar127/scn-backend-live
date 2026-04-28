import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history';

  const HistoryScreen({super.key});

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: const Color(0xFFC084FC)),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFEDE9FE),
                  height: 1.45,
                ),
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
    String? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: GlassCard(
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9333EA),
                      Color(0xFF38BDF8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFEDE9FE),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                Text(
                  trailing,
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _shortDate(dynamic value) {
    if (value == null) return 'Recent';

    try {
      final date = value.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  Widget _quizTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.instance.getQuizHistoryStream(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC084FC)),
          );
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

            final recommended =
            (item['recommendedField'] ?? 'Quiz Result').toString();
            final level = (item['educationLevel'] ?? 'Unknown').toString();
            final field = (item['selectedField'] ?? 'General').toString();
            final date = _shortDate(item['createdAt']);
            final score = item['matchPercent']?.toString();

            return _historyCard(
              title: recommended,
              subtitle: '$level • $field • $date',
              trailing: score == null ? null : '$score%',
              icon: Icons.quiz_rounded,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/roadmap',
                  arguments: {
                    'chosenPath': recommended,
                    'field': field,
                    'educationLevel': level,
                  },
                );
              },
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
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC084FC)),
          );
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
        backgroundColor: const Color(0xFF070018),
        appBar: AppBar(
          title: const Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: const Color(0xFF070018),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Color(0xFFC084FC),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFEDE9FE),
            tabs: [
              Tab(text: 'Quiz'),
              Tab(text: 'Chat'),
            ],
          ),
        ),
        body: GradientBackground(
          child: TabBarView(
            children: [
              _quizTab(),
              _chatTab(),
            ],
          ),
        ),
      ),
    );
  }
}