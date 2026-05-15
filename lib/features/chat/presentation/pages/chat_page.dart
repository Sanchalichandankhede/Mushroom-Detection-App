import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/quick_actions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am your Mushroom Expert AI. 🍄\n\nHow can I help you today? I can provide recipes, identify harmful types, or give medical consultancy regarding fungi.',
      'time': DateFormat('hh:mm a').format(DateTime.now()),
    },
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = {
      'isUser': true,
      'text': text,
      'time': DateFormat('hh:mm a').format(DateTime.now()),
    };

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    
    _scrollToBottom();

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) throw Exception("User not authenticated");

      // Prepare history for backend
      final history = _messages.skip(1).take(_messages.length - 2).map((msg) {
        return {
          'role': msg['isUser'] == true ? 'user' : 'model',
          'text': msg['text'],
        };
      }).toList();

      final response = await http.post(
        Uri.parse(ApiConfig.getUrl('/api/chat/')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'message': text,
          'history': history,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiText = data['response'] ?? 'I am sorry, I could not process that request.';

        if (mounted) {
          setState(() {
            _messages.add({
              'isUser': false,
              'text': aiText,
              'time': DateFormat('hh:mm a').format(DateTime.now()),
            });
            _isLoading = false;
          });
          _scrollToBottom();
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': 'Sorry, I encountered an error. Please check your connection and try again.',
            'time': DateFormat('hh:mm a').format(DateTime.now()),
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.bot, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mushroom Expert',
                  style: GoogleFonts.outfit(
                    color: AppColors.textHeadline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Online AI Assistant',
                  style: GoogleFonts.outfit(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.info, color: AppColors.textMuted, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: _messages[index]['text'],
                  isUser: _messages[index]['isUser'],
                  time: _messages[index]['time'],
                );
              },
            ),
          ),
          const QuickActions(),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Mushroom Expert is thinking...',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ).animate().fade().scale(),
            ),
          ChatInput(onSend: _handleSendMessage),
        ],
      ),
    );
  }
}
