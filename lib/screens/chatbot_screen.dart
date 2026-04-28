import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class ChatbotScreen extends StatefulWidget {
  static const String routeName = '/chatbot';

  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      'role': 'bot',
      'text':
      'Hi! I am SCN AI Advisor. Ap apna education level, field ya confusion batao, main guide karta hoon.'
    }
  ];

  bool isLoading = false;
  String educationLevel = 'Unknown';
  String selectedField = 'General';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      educationLevel = (args['educationLevel'] ?? 'Unknown').toString();
      selectedField = (args['selectedField'] ?? 'General').toString();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      isLoading = true;
    });

    messageController.clear();

    try {
      final reply = await AiService.instance.sendChatMessage(
        message: text,
        educationLevel: educationLevel,
        selectedField: selectedField,
      );

      if (!mounted) return;
      setState(() {
        messages.add({'role': 'bot', 'text': reply});
      });
    } catch (_) {
      setState(() {
        messages.add({
          'role': 'bot',
          'text':
          'SCN demo mode: Apna level aur field batao, main basic guidance de sakta hoon.'
        });
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget bubble(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 650),
        child: isUser
            ? Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF9333EA),
                Color(0xFF38BDF8),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22),
              topRight: const Radius.circular(22),
              bottomLeft: const Radius.circular(22),
              bottomRight: Radius.circular(isUser ? 4 : 22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            msg['text'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            : GlassCard(
          child: Text(
            msg['text'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget typing() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: GlassCard(
          child: Text(
            'SCN is typing...',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 980 : double.infinity,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, isDesktop ? 18 : 8, 16, 12),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2D006B),
                        Color(0xFF7C3AED),
                        Color(0xFF38BDF8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.30),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SCN AI Advisor',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ask career questions in English, Urdu, or Roman Urdu',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    children: [
                      ...messages.map(bubble),
                      if (isLoading) typing(),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            minLines: 1,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 14),
                            ),
                            onSubmitted: (_) => sendMessage(),
                          ),
                        ),
                        InkWell(
                          onTap: isLoading ? null : sendMessage,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9333EA),
                                  Color(0xFF38BDF8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}