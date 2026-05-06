import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_card.dart';

class QuickFactCapsule extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const QuickFactCapsule({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
