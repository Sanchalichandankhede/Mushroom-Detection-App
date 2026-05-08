import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import '../widgets/listing_card.dart';
import '../widgets/create_listing_bottom_sheet.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  List _listings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final response = await http.get(
        Uri.parse(ApiConfig.getUrl('/api/mushrooms/listings/me')),
        headers: {'Authorization': 'Bearer ${session?.accessToken}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _listings = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching listings: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showCreateListingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateListingBottomSheet(),
    ).then((value) {
      if (value == true) _fetchListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('My Listings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textHeadline,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: AppColors.primary),
            onPressed: _showCreateListingModal,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchListings,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _listings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _listings.length,
                    itemBuilder: (context, index) => ListingCard(listing: _listings[index]),
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(LucideIcons.shoppingBag, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'No listings yet',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
          ),
          const SizedBox(height: 8),
          Text('Start selling your harvest today!', style: GoogleFonts.outfit(color: AppColors.textMuted)),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _showCreateListingModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text('Create Listing', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
