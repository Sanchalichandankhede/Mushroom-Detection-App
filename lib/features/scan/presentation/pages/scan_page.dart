import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import '../widgets/scan_box.dart';
import '../widgets/scan_action_button.dart';
import '../widgets/recent_scans_section.dart';

class MushroomScanPage extends StatefulWidget {
  const MushroomScanPage({super.key});

  @override
  State<MushroomScanPage> createState() => _MushroomScanPageState();
}

class _MushroomScanPageState extends State<MushroomScanPage> {
  List _recentScans = [];
  bool _isLoadingScans = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentScans();
  }

  Future<void> _fetchRecentScans() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final response = await http.get(
        Uri.parse(ApiConfig.getUrl('/api/identify/history')),
        headers: {'Authorization': 'Bearer ${session?.accessToken}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _recentScans = jsonDecode(response.body);
          _isLoadingScans = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching scans: $e');
      if (mounted) setState(() => _isLoadingScans = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            const _ScanHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: ScanBox(),
                    ),
                    const SizedBox(height: 32),
                    const _ScanInstructions(),
                    const SizedBox(height: 24),
                    ScanActionButton(onTap: () {
                      // Future: Implementation of actual scan trigger
                    }),
                    const SizedBox(height: 48),
                    _isLoadingScans 
                      ? const CircularProgressIndicator()
                      : RecentScansSection(scans: _recentScans),
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
  const _ScanHeader();
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
            onPressed: () {
              // Navigation to full history page
              Navigator.pushNamed(context, '/profile/history');
            },
          ),
        ],
      ),
    );
  }
}

class _ScanInstructions extends StatelessWidget {
  const _ScanInstructions();
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