import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  final ValueChanged<String> onTap;

  const QuickActions({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': LucideIcons.utensils,
        'label': 'Recipes',
        'prompt': 'Give me some delicious mushroom-based recipes',
      },
      {
        'icon': LucideIcons.skull,
        'label': 'Toxic Check',
        'prompt': 'How can I check if a mushroom is toxic and what safety precautions should I take?',
      },
      {
        'icon': LucideIcons.sprout,
        'label': 'Growing Tips',
        'prompt': 'Can you give me some tips for growing mushrooms at home?',
      },
      {
        'icon': LucideIcons.heartPulse,
        'label': 'Medical Use',
        'prompt': 'What are the medicinal benefits and health properties of mushrooms?',
      },
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
              onPressed: () => onTap(action['prompt'] as String),
            ),
          );
        },
      ),
    );
  }
}
