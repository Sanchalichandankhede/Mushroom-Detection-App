import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../scan/presentation/pages/scan_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 1; // Default to Scan Page

  final List<Widget> _pages = [
    const HomePage(),
    const MushroomScanPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}
