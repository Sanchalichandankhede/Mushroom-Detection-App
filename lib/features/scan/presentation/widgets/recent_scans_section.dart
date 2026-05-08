import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/config/api_config.dart';

class RecentScansSection extends StatelessWidget {
  final List scans;
  const RecentScansSection({super.key, required this.scans});

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Scans',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeadline,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              return _RecentScanCard(scan: scan, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _RecentScanCard extends StatelessWidget {
  final Map<String, dynamic> scan;
  final int index;
  const _RecentScanCard({required this.scan, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Expanded(
            child: AppCard(
              padding: EdgeInsets.zero,
              borderRadius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  ApiConfig.getUrl(scan['uploaded_image_path']),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            scan['predicted_name'] ?? 'Unknown',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeadline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${(scan['confidence_score'] * 100).toInt()}%',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9));
  }
}
