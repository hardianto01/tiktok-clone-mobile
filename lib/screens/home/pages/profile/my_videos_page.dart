// lib/screens/home/pages/profile/my_videos_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/api_service.dart';

class MyVideosPage extends StatefulWidget {
  const MyVideosPage({super.key});

  @override
  State<MyVideosPage> createState() => _MyVideosPageState();
}

class _MyVideosPageState extends State<MyVideosPage> {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      try {
        final response = await ApiService.getUserVideos(authProvider.user!.id);
        if (response != null && response['data'] != null) {
          setState(() {
            _videos = List<Map<String, dynamic>>.from(response['data']);
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Video Saya', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/upload'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _videos.isEmpty
              ? _buildEmptyState()
              : _buildVideoList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text('Belum ada video', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
          const SizedBox(height: 8),
          Text('Upload video pertama Anda', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/upload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Upload Video', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: _loadVideos,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 9 / 16,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return _buildVideoItem(video);
        },
      ),
    );
  }

  Widget _buildVideoItem(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () => _showVideoDetails(video),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[900],
        ),
        child: Stack(
          children: [
            // Thumbnail or placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
              ),
            ),
            
            // Video info overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'] ?? 'Untitled',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.grey[400], size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${video['views_count'] ?? 0}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
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

  void _showVideoDetails(Map<String, dynamic> video) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video['title'] ?? 'Untitled',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (video['description'] != null)
                Text(
                  video['description'],
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatChip(Icons.visibility, '${video['views_count'] ?? 0}'),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.favorite, '${video['likes_count'] ?? 0}'),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.comment, '${video['comments_count'] ?? 0}'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to video player
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Lihat Video', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _deleteVideo(video),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  void _deleteVideo(Map<String, dynamic> video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Hapus Video', style: TextStyle(color: Colors.white)),
        content: const Text('Apakah Anda yakin ingin menghapus video ini?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _performDelete(video['id']);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(int videoId) async {
    // Implement delete API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video berhasil dihapus'), backgroundColor: Colors.green),
    );
    _loadVideos(); // Refresh list
  }
}