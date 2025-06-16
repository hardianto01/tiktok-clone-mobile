// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_navigation.dart';
import '../../providers/video_provider.dart';
import 'components/sidebar/sidebar_widget.dart';
import 'components/topbar/topbar_widget.dart';
import 'pages/suggestion/suggestion_page.dart';
import 'pages/explore/explore_page.dart';
import 'pages/following/following_page.dart';
import 'pages/friends/friends_page.dart';
import 'pages/activity/activity_page.dart';
import 'pages/messages/messages_page.dart';
import 'pages/live/live_page.dart';
import 'pages/profile/profile_page.dart';
import '../home/pages/friends/friends_page.dart';
import '../home/pages/following/following_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.loadCategories();
    });
  }

  // Check if current page should be full screen
  bool get isFullScreenPage {
    return _currentIndex == 0 || _currentIndex == 2; // Suggestion and Following
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isFullScreenPage && !isWideScreen
          ? _buildFullScreenLayout()
          : _buildDesktopLayout(isWideScreen),
      bottomNavigationBar: !isWideScreen
          ? CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            )
          : null,
    );
  }

  Widget _buildFullScreenLayout() {
    return Stack(
      children: [
        // Full screen video content
        _buildCurrentScreen(),

        // Top overlay with tabs (for mobile)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Navigation tabs
              Row(
                children: [
                  if (_currentIndex == 0) ...[
                    _buildTopTab('Live', false, 7),
                    const SizedBox(width: 20),
                    _buildTopTab('Mengikuti', false, 2),
                    const SizedBox(width: 20),
                    _buildTopTab('Untuk Anda', true, 0),
                  ] else if (_currentIndex == 2) ...[
                    _buildTopTab('Mengikuti', true, 2),
                    const SizedBox(width: 20),
                    _buildTopTab('Untuk Anda', false, 0),
                  ],
                ],
              ),

              // Search icon
              GestureDetector(
                onTap: () {
                  setState(
                      () => _currentIndex = 1); // Navigate to explore/search
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isWideScreen) {
    return Row(
      children: [
        // Fixed Sidebar for desktop
        if (isWideScreen)
          SidebarWidget(
            currentIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
            },
          ),

        // Main Content
        Expanded(
          child: Column(
            children: [
              if (isWideScreen && !isFullScreenPage)
                TopbarWidget(
                  title: _getPageTitle(),
                  showSearch: true,
                ),
              Expanded(child: _buildCurrentScreen()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopTab(String title, bool isSelected, int targetIndex) {
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = targetIndex);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Saran';
      case 1:
        return 'Jelajahi';
      case 2:
        return 'Mengikuti';
      case 3:
        return 'Teman';
      case 5:
        return 'Aktivitas';
      case 6:
        return 'Pesan';
      case 7:
        return 'LIVE';
      case 8:
        return 'Profil';
      default:
        return 'TikTok';
    }
  }

  Widget _buildCurrentScreen() {
    print('Current index: $_currentIndex');

    switch (_currentIndex) {
      case 0:
        return const SuggestionPage();
      case 1:
        return const ExplorePage();
      case 2:
        return const FollowingPage();
      case 3:
        return const FriendsPage();
      case 5:
        return const ActivityPage();
      case 6:
        return const MessagesPage();
      case 7:
        return const LivePage();
      case 8:
        return const ProfilePage();
      default:
        return const SuggestionPage();
    }
  }
}
