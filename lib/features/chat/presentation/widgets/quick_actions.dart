import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': LucideIcons.utensils, 'label': 'Recipes'},
      {'icon': LucideIcons.skull, 'label': 'Toxic Check'},
      {'icon': LucideIcons.sprout, 'label': 'Growing Tips'},
      {'icon': LucideIcons.heartPulse, 'label': 'Medical Use'},
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ActionChip(
              avatar: Icon(action['icon'] as IconData, size: 16, color: AppColors.primary),
              label: Text(
                action['label'] as String,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeadline,
                ),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey[200]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
