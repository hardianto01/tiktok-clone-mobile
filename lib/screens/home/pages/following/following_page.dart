// lib/screens/home/pages/following/following_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/video_provider.dart';
import '../../../../constants/app_icons.dart';
import 'following_video_card.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final PageController _pageController = PageController();
  int _currentVideoIndex = 0;

  // Sample data for followed users - in real app this would come from your backend
  final List<Map<String, dynamic>> _followingVideos = [
    {
      'id': '1',
      'username': 'labildev',
      'displayName': 'Labil Dev',
      'description': 'aku dengan laptopku 💻 #coding #developer #tech',
      'videoUrl': '',
      'userAvatar': '',
      'isVerified': false,
      'likes': 334,
      'comments': 1,
      'shares': 17,
      'bookmarks': 40,
      'duration': '4:15',
      'hashtags': ['#finLabil', '#jokiskripsi', '...'],
      'musicName': 'lebih banyak',
      'isFollowing': true,
    },
    {
      'id': '2',
      'username': 'techguru_id',
      'displayName': 'Tech Guru',
      'description': 'Tutorial Flutter untuk pemula 🔥 #flutter #mobile #tutorial',
      'videoUrl': '',
      'userAvatar': '',
      'isVerified': true,
      'likes': 1245,
      'comments': 89,
      'shares': 156,
      'bookmarks': 234,
      'duration': '2:30',
      'hashtags': ['#flutter', '#tutorial', '#mobile'],
      'musicName': 'coding beats',
      'isFollowing': true,
    },
    {
      'id': '3',
      'username': 'designerlife',
      'displayName': 'UI Designer',
      'description': 'UI/UX tips yang wajib kalian tau! ✨ #design #uiux #tips',
      'videoUrl': '',
      'userAvatar': '',
      'isVerified': false,
      'likes': 892,
      'comments': 45,
      'shares': 67,
      'bookmarks': 123,
      'duration': '1:45',
      'hashtags': ['#design', '#uiux', '#tips'],
      'musicName': 'creative vibes',
      'isFollowing': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load following videos from your backend here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      // videoProvider.loadFollowingVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _followingVideos.isEmpty 
          ? _buildEmptyState()
          : _buildVideoFeed(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.following,
              size: 60,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Video dari akun yang Anda ikuti\nakan muncul di sini',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to explore page to find users to follow
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Temukan akun untuk diikuti',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoFeed() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _followingVideos.length,
      onPageChanged: (index) {
        setState(() {
          _currentVideoIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return FollowingVideoCard(
          video: _followingVideos[index],
          isCurrentVideo: index == _currentVideoIndex,
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}