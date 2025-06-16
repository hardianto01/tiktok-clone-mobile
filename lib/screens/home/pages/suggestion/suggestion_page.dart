// lib/screens/home/pages/suggestion/suggestion_page.dart - Fixed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/video_provider.dart';
import '../../../../constants/app_icons.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.loadVideos(selectedCategory);
    });
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.loadMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: Consumer<VideoProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.videos.isEmpty) {
                  return _buildLoadingState();
                }

                if (provider.hasError && provider.videos.isEmpty) {
                  return _buildErrorState(provider.errorMessage ?? 'Unknown error');
                }

                if (provider.videos.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildVideoFeed(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = selectedCategory == category.slug;
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category.slug;
                    });
                    provider.loadVideos(selectedCategory);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey[600]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[300],
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoFeed(VideoProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.loadVideos(selectedCategory),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context),
                childAspectRatio: 9 / 16,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = provider.videos[index];
                  return _buildVideoCard(video, index);
                },
                childCount: provider.videos.length,
              ),
            ),
          ),
          
          if (provider.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video, int index) {
    final heights = [280.0, 320.0, 300.0, 360.0, 290.0, 340.0, 310.0, 330.0];
    final height = heights[index % heights.length];
    
    return GestureDetector(
      onTap: () => _openMediaViewer(video),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildVideoBackground(),
              _buildOverlay(),
              _buildVideoInfo(video),
              _buildPlayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(128, 0, 128, 0.4),
            Color.fromRGBO(0, 0, 255, 0.4),
            Color.fromRGBO(255, 192, 203, 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return const Center(
      child: Icon(
        Icons.play_circle_fill,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildVideoInfo(Map<String, dynamic> video) {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (video['title'] != null)
            Text(
              video['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (video['user'] != null) ...[
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.grey[600],
                  child: const Icon(Icons.person, size: 10, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '@${video['user']['username'] ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const Spacer(),
              if (video['views_count'] != null) ...[
                const Icon(Icons.visibility, size: 12, color: Colors.white70),
                const SizedBox(width: 2),
                Text(
                  _formatCount(video['views_count']),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _openMediaViewer(Map<String, dynamic> video) {
    Navigator.pushNamed(context, '/video_player', arguments: video);
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Loading videos...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<VideoProvider>(context, listen: false);
              provider.loadVideos(selectedCategory);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'No videos found',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to upload a video in this category!',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/upload'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Upload Video', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}