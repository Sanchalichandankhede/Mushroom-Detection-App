import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Terms of Service', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textHeadline,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Acceptance of Terms', 'By accessing or using the Mushroom Detection App, you agree to be bound by these Terms of Service.'),
            _buildSection('2. Identification Disclaimer', 'Mushroom identification via AI is for educational purposes only. Never consume any mushroom based solely on an AI prediction. Always consult an expert.'),
            _buildSection('3. User Conduct', 'Users must provide accurate information when listing mushrooms for sale. Fraudulent behavior will result in account termination.'),
            _buildSection('4. Marketplace Policy', 'We act as a platform for buyers and sellers. We are not responsible for the quality of mushrooms sold by third parties.'),
            _buildSection('5. Limitation of Liability', 'In no event shall Mycelial Layer be liable for any injury or poisoning resulting from mushroom consumption.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textHeadline)),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textHeadline.withValues(alpha: 0.7), height: 1.5)),
        ],
      ),
    );
  }
}
