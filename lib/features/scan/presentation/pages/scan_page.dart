import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/scan_box.dart';
import '../widgets/scan_action_button.dart';

class MushroomScanPage extends StatelessWidget {
  const MushroomScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _ScanHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ScanBox(),
                    const SizedBox(height: 48),
                    _ScanInstructions(),
                    const SizedBox(height: 32),
                    ScanActionButton(onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Text(
            'Identification',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeadline,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.history),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ScanInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ready to discover?',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Point your camera at a mushroom to identify it in seconds.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(color: AppColors.textMuted),
        ),
      ],
    );
  }
}