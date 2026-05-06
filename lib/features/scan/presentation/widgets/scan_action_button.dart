import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ScanActionButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScanActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(LucideIcons.camera, color: Colors.white, size: 28),
      ).animate(onPlay: (controller) => controller.repeat())
       .shimmer(duration: 2.seconds),
    );
  }
}
