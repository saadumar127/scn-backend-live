import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        constraints: const BoxConstraints(maxWidth: 290),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
            colors: [AppTheme.primary, AppTheme.secondary],
          )
              : null,
          color: isUser ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isUser ? null : Border.all(color: AppTheme.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}