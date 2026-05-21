import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
  });

  String _getCleanText(String text) {
    return text
        .replaceAll(RegExp(r'\*\*'), '') // Remove bold asterisks
        .replaceAll(RegExp(r'\*'), '')   // Remove italic asterisks
        .replaceAll(RegExp(r'#+\s*'), '') // Remove header hashtags (e.g. ###)
        .replaceAll(RegExp(r'---\s*'), '') // Remove horizontal line markers
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _getCleanText(message),
              style: GoogleFonts.outfit(
                color: isUser ? Colors.white : AppColors.textHeadline,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
