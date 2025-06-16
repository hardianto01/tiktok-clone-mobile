// lib/screens/home/pages/profile/profile_page.dart - Fixed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> allMedia = [];
  List<Map<String, dynamic>> videos = [];
  List<Map<String, dynamic>> photos = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadMedia();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadMedia() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await ApiService.getUserVideos(auth.user!.id);
      
      if (response != null && response['data'] != null) {
        final mediaList = List<Map<String, dynamic>>.from(response['data']);
        
        setState(() {
          allMedia = mediaList;
          videos = mediaList.where((media) => _isVideo(media)).toList();
          photos = mediaList.where((media) => !_isVideo(media)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load media';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  bool _isVideo(Map<String, dynamic> media) {
    if (media['video_url'] != null) {
      final url = media['video_url'] as String;
      final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v', '.3gp'];
      return videoExtensions.any((ext) => url.toLowerCase().contains(ext));
    }
    
    if (media['content_type'] != null) {
      return media['content_type'].toString().startsWith('video/');
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isAuthenticated) {
            return _buildLoginPrompt();
          }

          return RefreshIndicator(
            onRefresh: loadMedia,
            child: CustomScrollView(
              slivers: [
                _buildProfileHeader(auth.user!),
                _buildStatsSection(),
                _buildTabBar(),
                _buildTabContent(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Please login to view profile',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[700]!, width: 2),
              ),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.grey[800],
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage == null
                    ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                    : null,
              ),
            ),
            
            const SizedBox(width: 20),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      user.bio!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            Column(
              children: [
                IconButton(
                  onPressed: loadMedia,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'Refresh',
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/upload'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  tooltip: 'Upload',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('${allMedia.length}', 'Posts'),
            _buildStatItem('0', 'Followers'),
            _buildStatItem('0', 'Following'),
            _buildStatItem('${videos.length}', 'Videos'),
            _buildStatItem('${photos.length}', 'Photos'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[500],
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Videos'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (hasError) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(
                'Error loading content',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadMedia,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMediaGrid(allMedia, 'No content yet'),
          _buildMediaGrid(videos, 'No videos yet'),
          _buildMediaGrid(photos, 'No photos yet'),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<Map<String, dynamic>> mediaList, String emptyMessage) {
    if (mediaList.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return _buildMediaThumbnail(media);
      },
    );
  }

  Widget _buildMediaThumbnail(Map<String, dynamic> media) {
    final isVideo = _isVideo(media);
    
    return GestureDetector(
      onTap: () => _showMediaDetails(media),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[900],
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.purple.withValues(alpha: 0.3), Colors.blue.withValues(alpha: 0.3)],
                ),
              ),
              child: Center(
                child: Icon(
                  isVideo ? Icons.play_circle_fill : Icons.image,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media['title'] ?? 'Untitled',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.white70, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        '${media['views_count'] ?? 0}',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your first content',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/upload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Upload Content',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaDetails(Map<String, dynamic> media) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              media['title'] ?? 'Untitled',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (media['description'] != null)
              Text(
                media['description'],
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat(Icons.visibility, '${media['views_count'] ?? 0}'),
                const SizedBox(width: 16),
                _buildStat(Icons.favorite, '${media['likes_count'] ?? 0}'),
                const SizedBox(width: 16),
                _buildStat(Icons.comment, '${media['comments_count'] ?? 0}'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _openMedia(media);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(_isVideo(media) ? 'Play Video' : 'View Image', 
                      style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  void _openMedia(Map<String, dynamic> media) {
    if (_isVideo(media)) {
      Navigator.pushNamed(context, '/video_player', arguments: media);
    } else {
      Navigator.pushNamed(context, '/image_viewer', arguments: media);
    }
  }
}