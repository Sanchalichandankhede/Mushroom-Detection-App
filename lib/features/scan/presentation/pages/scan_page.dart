import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/widgets/app_card.dart';
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
  bool _isAnalyzing = false;
  String? _capturedImagePath;
  Map<String, dynamic>? _result;
  final ImagePicker _picker = ImagePicker();

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
        if (mounted) {
          setState(() {
            _recentScans = jsonDecode(response.body);
            _isLoadingScans = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching scans: $e');
      if (mounted) setState(() => _isLoadingScans = false);
    }
  }

  String _cleanMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'\*'), '')
        .replaceAll(RegExp(r'#+\s*'), '')
        .replaceAll(RegExp(r'---\s*'), '');
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Choose Image Source',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadline,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a photo or pick from your gallery',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SourceOption(
                      icon: LucideIcons.camera,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SourceOption(
                      icon: LucideIcons.image,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() {
        _capturedImagePath = image.path;
        _result = null;
        _isAnalyzing = true;
      });

      await _uploadAndAnalyze(image.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _uploadAndAnalyze(String filePath) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final uri = Uri.parse(ApiConfig.getUrl('/api/identify/upload'));

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${session?.accessToken}'
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _result = data;
            _isAnalyzing = false;
          });
          _fetchRecentScans();
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception('Server error (${response.statusCode})');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _resetScan() {
    setState(() {
      _capturedImagePath = null;
      _result = null;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        // Scan Box (image or placeholder)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ScanBox(imagePath: _capturedImagePath),
                        ),
                        const SizedBox(height: 32),

                        // Results or Instructions
                        if (_result != null)
                          _buildResultsSection()
                        else ...[
                          _buildInstructions(),
                          const SizedBox(height: 24),
                          ScanActionButton(onTap: _showImageSourceSheet),
                        ],

                        const SizedBox(height: 48),

                        // Recent Scans
                        _isLoadingScans
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : RecentScansSection(scans: _recentScans),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Full-screen loading overlay
          if (_isAnalyzing) _buildAnalyzingOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                LucideIcons.history,
                color: AppColors.textHeadline,
                size: 20,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile/history');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        Text(
          'Ready to discover?',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeadline,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Point your camera at a mushroom to identify it in seconds.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
        ),
      ],
    );
  }

  Widget _buildAnalyzingOverlay() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Analyzing mushroom...',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHeadline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This may take a moment',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.97, 0.97),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final data = _result!;
    final predictedName = data['predicted_name'] ?? 'Unknown';
    final confidence = ((data['confidence_score'] ?? 0) * 100).toInt();
    final category = (data['category'] ?? 'unknown').toString().toLowerCase();
    final isSafe = data['is_safe'] ?? false;
    final description = _cleanMarkdown(data['description'] ?? '');
    final toxicityStatus = data['toxicity_status'] ?? '';
    final toxicityDetails = _cleanMarkdown(data['toxicity_details'] ?? '');
    final healthMetrics = _cleanMarkdown(data['health_metrics'] ?? '');
    final recipes =
        (data['recipes'] as List<dynamic>?)
            ?.map((r) => _cleanMarkdown(r.toString()))
            .toList() ??
        [];
    final warnings = data['warnings'] as String?;

    Color badgeColor;
    String badgeLabel;
    IconData badgeIcon;

    if (category == 'poisonous' || !isSafe) {
      badgeColor = const Color(0xFFDC3545);
      badgeLabel = toxicityStatus.isNotEmpty ? toxicityStatus : 'Toxic';
      badgeIcon = LucideIcons.alertTriangle;
    } else if (category == 'edible') {
      badgeColor = const Color(0xFF28A745);
      badgeLabel = toxicityStatus.isNotEmpty ? toxicityStatus : 'Edible';
      badgeIcon = LucideIcons.shieldCheck;
    } else if (category == 'medicinal') {
      badgeColor = const Color(0xFF6F42C1);
      badgeLabel = toxicityStatus.isNotEmpty ? toxicityStatus : 'Medicinal';
      badgeIcon = LucideIcons.heart;
    } else {
      badgeColor = const Color(0xFFFF9500);
      badgeLabel = toxicityStatus.isNotEmpty ? toxicityStatus : 'Unknown';
      badgeIcon = LucideIcons.helpCircle;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Badges row
          AppCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  predictedName,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeadline,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Confidence badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.target,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$confidence% match',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Safety badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badgeIcon, size: 14, color: badgeColor),
                          const SizedBox(width: 6),
                          Text(
                            badgeLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15),

          // Warnings banner
          if (warnings != null && warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFD43B).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.alertTriangle,
                    size: 18,
                    color: Colors.orange[800],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _cleanMarkdown(warnings),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.orange[900],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          ],

          // Toxicity Details
          if (toxicityDetails.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildDetailCard(
              icon: LucideIcons.shield,
              title: 'Toxicity Details',
              content: toxicityDetails,
              accentColor: badgeColor,
              delay: 200,
            ),
          ],

          // Health Metrics
          if (healthMetrics.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: LucideIcons.activity,
              title: 'Health Metrics',
              content: healthMetrics,
              accentColor: const Color(0xFF17A2B8),
              delay: 300,
            ),
          ],

          // Recipes
          if (recipes.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Recipes',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeadline,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
            const SizedBox(height: 12),
            ...recipes.asMap().entries.map((entry) {
              final idx = entry.key;
              final recipe = entry.value;
              return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              recipe,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.textHeadline,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: (450 + idx * 80).ms, duration: 400.ms)
                  .slideX(begin: 0.1);
            }),
          ],

          // Scan Again button
          const SizedBox(height: 28),
          Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _resetScan,
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    label: Text(
                      'Scan Again',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 600.ms, duration: 400.ms)
              .slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required Color accentColor,
    int delay = 0,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: accentColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textMuted,
              height: 1.65,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms, duration: 400.ms).slideY(begin: 0.1);
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeadline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
