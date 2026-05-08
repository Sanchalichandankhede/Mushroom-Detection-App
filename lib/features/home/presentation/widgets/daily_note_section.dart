import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class DailyNoteSection extends StatelessWidget {
  final String note;
  const DailyNoteSection({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppCard(
        color: const Color(0xFFE8F5E9),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        child: Row(
          children: [
            Icon(LucideIcons.quote, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FORAGER\'S NOTE',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"$note"',
                    style: GoogleFonts.outfit(fontSize: 14, fontStyle: FontStyle.italic, color: AppColors.textHeadline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
    );
  }
}
