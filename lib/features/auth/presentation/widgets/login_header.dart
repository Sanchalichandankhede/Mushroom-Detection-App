import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.leaf, color: Color(0xFF8BCC3A), size: 32),
                const SizedBox(width: 12),
                Text(
                  'Mycelial Layer',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Identify, catalog, and explore the\nhidden kingdoms of the forest floor\nwith expert-level precision.',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF8BCC3A), borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Container(width: 12, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Container(width: 12, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}