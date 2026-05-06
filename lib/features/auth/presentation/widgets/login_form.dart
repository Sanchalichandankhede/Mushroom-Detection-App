import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bouncing_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        // redirectTo: 'io.supabase.flutter://login-callback', // Configure in dashboard
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Continue your mycological journey.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                icon: LucideIcons.chrome,
                label: 'Google',
                onTap: _signInWithGoogle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSocialButton(
                icon: LucideIcons.apple,
                label: 'Apple',
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'OR EMAIL',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 32),
        _buildFieldLabel('EMAIL ADDRESS'),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(LucideIcons.mail, size: 20),
            hintText: 'forager@forest.com',
            hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFieldLabel('PASSWORD'),
            Text(
              'Forgot?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(LucideIcons.lock, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 20,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            hintText: '••••••••',
            hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) => setState(() => _rememberMe = val!),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Keep me logged in for 30 days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textBody,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        BouncingWidget(
          onPress: _isLoading ? () {} : _signIn,
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withBlue(20),
                ],
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Enter the Mycelial Layer',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.textBody,
              ),
              children: [
                const TextSpan(text: 'New to the field guide? '),
                TextSpan(
                  text: 'Create an account',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushNamed(context, '/register'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              Text(
                'BY ENTERING, YOU AGREE TO OUR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SAFETY PROTOCOLS & FIELD TERMS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeadline,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, VoidCallback? onTap}) {
    return BouncingWidget(
      onPress: onTap ?? () {},
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textHeadline),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: AppColors.textHeadline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}