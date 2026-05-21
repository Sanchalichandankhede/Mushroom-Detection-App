import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ScanBox extends StatelessWidget {
  final String? imagePath;

  const ScanBox({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: imagePath != null
              ? Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : _buildScanPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildScanPlaceholder() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          LucideIcons.scan,
          size: 120,
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        ...List.generate(4, (index) {
          return Positioned(
            top: index < 2 ? 40 : null,
            bottom: index >= 2 ? 40 : null,
            left: index % 2 == 0 ? 40 : null,
            right: index % 2 != 0 ? 40 : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  top: index < 2
                      ? BorderSide(color: AppColors.primary, width: 4)
                      : BorderSide.none,
                  bottom: index >= 2
                      ? BorderSide(color: AppColors.primary, width: 4)
                      : BorderSide.none,
                  left: index % 2 == 0
                      ? BorderSide(color: AppColors.primary, width: 4)
                      : BorderSide.none,
                  right: index % 2 != 0
                      ? BorderSide(color: AppColors.primary, width: 4)
                      : BorderSide.none,
                ),
              ),
            ),
          );
        }),
      ],
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: 2.seconds);
  }
}
