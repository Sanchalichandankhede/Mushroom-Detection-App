import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/quick_fact_capsule.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(),
              const SizedBox(height: 32),
              _QuickFactsSection(),
              const SizedBox(height: 24),
              _DailyNoteSection(),
              const SizedBox(height: 32),
              _ExploreArticlesSection(),
              const SizedBox(height: 32),
              _RecentUpdatesSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning,', style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMuted)),
              Text(
                'Piyush Forager',
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
              ),
            ],
          ),
          AppCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 14,
            child: const Icon(LucideIcons.bell, size: 22),
          ),
        ],
      ),
    );
  }
}

class _QuickFactsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final facts = [
      {'icon': LucideIcons.zap, 'label': 'Fast ID', 'color': Colors.amber},
      {'icon': LucideIcons.shieldCheck, 'label': 'Safe', 'color': Colors.green},
      {'icon': LucideIcons.globe, 'label': 'Global', 'color': Colors.blue},
      {'icon': LucideIcons.users, 'label': 'Experts', 'color': Colors.purple},
    ];

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
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: QuickFactCapsule(
                    icon: fact['icon'] as IconData,
                    label: fact['label'] as String,
                    color: fact['color'] as Color,
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.8, 0.8));
            },
          ),
        ),
      ],
    );
  }
}

class _DailyNoteSection extends StatelessWidget {
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
                    '"Fungi are the interface organisms between life and death."',
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

class _ExploreArticlesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SectionHeader(title: 'Explore Articles', actionLabel: 'View All'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return _ArticleLargeCard(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _ArticleLargeCard extends StatelessWidget {
  final int index;
  const _ArticleLargeCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final titles = ['The Secret Life of Fungi', 'Edible vs. Poisonous Guide', 'Medicinal Mushrooms 101'];
    final images = [
      'https://images.unsplash.com/photo-1505820013142-f86a3439c5b2?w=400&q=80',
      'https://images.unsplash.com/photo-1544070078-a212eda27b49?w=400&q=80',
      'https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&q=80',
    ];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: AppCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  image: DecorationImage(image: NetworkImage(images[index]), fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[index], style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Learn the hidden mysteries of the forest floor...',
                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 200).ms).slideY(begin: 0.1, end: 0);
  }
}

class _RecentUpdatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SectionHeader(title: 'Recent Updates'),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _ArticleSmallTile(index: index);
          },
        ),
      ],
    );
  }
}

class _ArticleSmallTile extends StatelessWidget {
  final int index;
  const _ArticleSmallTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final titles = ['New Species Discovered in Amazon', 'Foraging Safety Tips for Spring', 'Sustainability in Mushroom Farming'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 20,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[index], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Read more • 5 min read', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 150).ms);
  }
}
