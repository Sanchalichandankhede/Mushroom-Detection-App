import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/api_config.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_facts_section.dart';
import '../widgets/daily_note_section.dart';
import '../widgets/explore_articles_section.dart';
import '../widgets/recipes_section.dart';
import '../widgets/recent_updates_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _homeData = {
    'userName': 'User',
    'quickFacts': [],
    'dailyNote': 'Loading your daily mushroom tip...',
    'articles': [],
    'recipes': [],
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final userResponse = await http.get(
        Uri.parse(ApiConfig.getUrl('/api/auth/me')),
        headers: {'Authorization': 'Bearer ${session?.accessToken}'},
      );
      
      final factsResponse = await http.get(Uri.parse(ApiConfig.getUrl('/api/home/quick-facts')));
      final articlesResponse = await http.get(Uri.parse(ApiConfig.getUrl('/api/home/articles')));
      final noteResponse = await http.get(Uri.parse(ApiConfig.getUrl('/api/home/daily-note')));
      final recipesResponse = await http.get(Uri.parse(ApiConfig.getUrl('/api/home/recipes')));

      if (mounted) {
        setState(() {
          if (userResponse.statusCode == 200) {
            _homeData['userName'] = jsonDecode(userResponse.body)['name'];
          }
          if (factsResponse.statusCode == 200) {
            _homeData['quickFacts'] = jsonDecode(factsResponse.body);
          }
          if (articlesResponse.statusCode == 200) {
            _homeData['articles'] = jsonDecode(articlesResponse.body);
          }
          if (noteResponse.statusCode == 200) {
            _homeData['dailyNote'] = jsonDecode(noteResponse.body)['note'];
          }
          if (recipesResponse.statusCode == 200) {
            _homeData['recipes'] = jsonDecode(recipesResponse.body);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: _fetchHomeData,
        child: SafeArea(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(userName: _homeData['userName']),
                    const SizedBox(height: 32),
                    QuickFactsSection(facts: _homeData['quickFacts']),
                    const SizedBox(height: 24),
                    DailyNoteSection(note: _homeData['dailyNote']),
                    const SizedBox(height: 32),
                    ExploreArticlesSection(articles: _homeData['articles']),
                    const SizedBox(height: 32),
                    RecipesSection(recipes: _homeData['recipes']),
                    const SizedBox(height: 32),
                    RecentUpdatesSection(articles: _homeData['articles']),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
