import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primary.withBlue(40)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(LucideIcons.user, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.email ?? 'Forager',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Account Settings'),
                  _buildSettingTile(LucideIcons.user, 'Personal Information'),
                  _buildSettingTile(LucideIcons.shoppingBag, 'My Listings'),
                  _buildSettingTile(LucideIcons.history, 'Identification History'),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Preferences'),
                  _buildSettingTile(LucideIcons.bell, 'Notifications'),
                  _buildSettingTile(LucideIcons.shield, 'Privacy & Safety'),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textHeadline, size: 22),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            color: AppColors.textHeadline,
          ),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 18),
        onTap: () {},
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Supabase.instance.client.auth.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.logOut, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              'Sign Out',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
