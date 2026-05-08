import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/quick_fact_capsule.dart';

class QuickFactsSection extends StatelessWidget {
  final List facts;
  const QuickFactsSection({super.key, required this.facts});

  @override
  Widget build(BuildContext context) {
    if (facts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SectionHeader(title: 'Quick Facts'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: facts.length,
            itemBuilder: (context, index) {
              final fact = facts[index];
              return SizedBox(
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: QuickFactCapsule(
                    icon: _getIcon(fact['icon']),
                    label: fact['fact'],
                    color: _getColor(fact['color_hex']),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.8, 0.8));
            },
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'zap': return LucideIcons.zap;
      case 'globe': return LucideIcons.globe;
      case 'lightbulb': return LucideIcons.lightbulb;
      case 'shield': return LucideIcons.shieldCheck;
      default: return LucideIcons.info;
    }
  }

  Color _getColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.amber;
    }
  }
}
