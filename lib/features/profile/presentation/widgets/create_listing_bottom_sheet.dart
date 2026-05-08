import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';

class CreateListingBottomSheet extends StatefulWidget {
  const CreateListingBottomSheet({super.key});

  @override
  State<CreateListingBottomSheet> createState() => _CreateListingBottomSheetState();
}

class _CreateListingBottomSheetState extends State<CreateListingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  bool _isOrganic = false;
  bool _isSaving = false;
  
  List _mushrooms = [];
  int? _selectedMushroomId;
  bool _loadingMushrooms = true;

  @override
  void initState() {
    super.initState();
    _fetchMushrooms();
  }

  Future<void> _fetchMushrooms() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getUrl('/api/mushrooms/')));
      if (response.statusCode == 200) {
        setState(() {
          _mushrooms = jsonDecode(response.body);
          _loadingMushrooms = false;
        });
      }
    } catch (e) {
      setState(() => _loadingMushrooms = false);
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate() || _selectedMushroomId == null) return;

    setState(() => _isSaving = true);
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final response = await http.post(
        Uri.parse(ApiConfig.getUrl('/api/mushrooms/listings/')),
        headers: {
          'Authorization': 'Bearer ${session?.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mushroom_id': _selectedMushroomId,
          'title': _titleController.text,
          'description': _descController.text,
          'price_per_kg': double.parse(_priceController.text),
          'quantity_kg': double.parse(_qtyController.text),
          'is_organic': _isOrganic,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) Navigator.pop(context, true);
      } else {
        throw Exception('Failed to create listing');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create New Listing',
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textHeadline),
              ),
              const SizedBox(height: 24),
              
              _buildLabel('Mushroom Type'),
              const SizedBox(height: 8),
              _loadingMushrooms 
                ? const LinearProgressIndicator()
                : DropdownButtonFormField<int>(
                    decoration: _inputDecoration(LucideIcons.search, 'Select mushroom'),
                    value: _selectedMushroomId,
                    items: _mushrooms.map<DropdownMenuItem<int>>((m) {
                      return DropdownMenuItem<int>(
                        value: m['id'],
                        child: Text(m['common_name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMushroomId = val),
                    validator: (val) => val == null ? 'Please select a type' : null,
                  ),
              
              const SizedBox(height: 16),
              _buildLabel('Listing Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration(LucideIcons.type, 'Fresh Oyster Mushrooms...'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Price (\$/kg)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(LucideIcons.dollarSign, '12.50'),
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Quantity (kg)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _qtyController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(LucideIcons.layers, '5.0'),
                          validator: (val) => val!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('Organic Certified', style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
                value: _isOrganic,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isOrganic = val),
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSaving 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Publish Listing', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textHeadline));
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary, width: 2)),
    );
  }
}
