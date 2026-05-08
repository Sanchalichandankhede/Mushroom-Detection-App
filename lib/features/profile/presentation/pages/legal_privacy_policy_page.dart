import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class LegalPrivacyPolicyPage extends StatelessWidget {
  const LegalPrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Privacy Policy', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textHeadline,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Data Collection', 'We collect your name, email address, and profile image when you register. We also store identification logs and marketplace listings you create.'),
            _buildSection('2. Image Usage', 'Photos uploaded for identification are used to improve our ML models and are stored securely on our servers.'),
            _buildSection('3. Third-Party Services', 'We use Supabase for authentication and database management. Your payment details are processed securely via third-party providers.'),
            _buildSection('4. Cookies', 'We use local storage to keep you logged in and remember your preferences.'),
            _buildSection('5. Your Rights', 'You have the right to access, correct, or delete your personal data at any time via the settings menu.'),
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
