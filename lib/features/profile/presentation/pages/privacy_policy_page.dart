import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import 'terms_of_service_page.dart';
import 'legal_privacy_policy_page.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _isDeleting = false;

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final response = await http.delete(
        Uri.parse(ApiConfig.getUrl('/api/auth/me')),
        headers: {'Authorization': 'Bearer ${session?.accessToken}'},
      );

      if (response.statusCode == 204) {
        await Supabase.instance.client.auth.signOut();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully.')),
          );
        }
      } else {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  void _showDeleteWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text(
          'This action is permanent and cannot be undone. All your listings, identification history, and profile data will be deleted forever.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text('Delete Forever', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Privacy & Safety', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textHeadline,
        elevation: 0,
      ),
      body: _isDeleting 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderIcon(),
                const SizedBox(height: 32),
                _buildSection(
                  'Your Data Safety',
                  'We take your privacy seriously. All mushroom identification photos and personal details are stored securely using Supabase encryption.',
                ),
                _buildSection(
                  'Location Privacy',
                  'We only use your location to help you find local mushroom listings. Your exact GPS coordinates are never shared with other users.',
                ),
                _buildSection(
                  'Marketplace Security',
                  'Payments are handled through secure gateways. We never store your credit card information on our servers.',
                ),
                const SizedBox(height: 32),
                _buildTile(
                  LucideIcons.fileText, 
                  'Terms of Service', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServicePage())),
                ),
                _buildTile(
                  LucideIcons.lock, 
                  'Privacy Policy', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LegalPrivacyPolicyPage())),
                ),
                _buildTile(
                  LucideIcons.userX, 
                  'Delete Account', 
                  color: Colors.red,
                  onTap: _showDeleteWarning,
                ),
                const SizedBox(height: 48),
                Center(
                  child: Text(
                    'Version 1.0.0 (Build 2024)',
                    style: GoogleFonts.outfit(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildHeaderIcon() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(LucideIcons.shieldCheck, size: 48, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textHeadline.withValues(alpha: 0.7), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.textHeadline, size: 20),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textHeadline,
          ),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 18),
        onTap: onTap,
      ),
    );
  }
}
