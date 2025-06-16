// lib/screens/home/pages/explore/explore_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/video_provider.dart';
import '../../../../models/category.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _currentCategory = 'semua'; // Default category

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VideoProvider>(context, listen: false);
      provider.loadCategories();
      provider.loadVideos(_currentCategory);
    });
  }

  void _onCategorySelected(String slug) {
    setState(() {
      _currentCategory = slug;
    });
    final provider = Provider.of<VideoProvider>(context, listen: false);
    provider.loadVideos(slug);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Consumer<VideoProvider>(
            builder: (context, videoProvider, child) {
              return CategoryTabs(
                categories: videoProvider.categories,
                selectedCategory: _currentCategory,
                onCategorySelected: _onCategorySelected,
              );
            },
          ),
          const Expanded(child: VideoGrid()),
        ],
      ),
    );
  }
}

class CategoryTabs extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.slug == selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => onCategorySelected(category.slug),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey[600]!,
                  ),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoGrid extends StatelessWidget {
  const VideoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        if (provider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, 
                     size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.errorMessage}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.refreshVideos(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library_outlined, 
                     size: 64, color: Colors.grey[600]),
                const SizedBox(height: 16),
                Text(
                  'No videos found',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: provider.videos.length,
          itemBuilder: (context, index) {
            final video = provider.videos[index];
            return VideoGridItem(video: video);
          },
        );
      },
    );
  }
}

class VideoGridItem extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoGridItem({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to video player
        Navigator.pushNamed(
          context,
          '/video_player',
          arguments: video,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: _buildThumbnail(),
              ),
            ),
            
            // Video Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    video['title']?.toString() ?? 'Untitled',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Username
                  Text(
                    '@${_getUserName()}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Stats
                  Row(
                    children: [
                      Icon(Icons.favorite, 
                           size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(video['likes_count']),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.visibility, 
                           size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(video['views_count']),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
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

  Widget _buildThumbnail() {
    final thumbnailUrl = video['thumbnail_url']?.toString();
    
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder();
          },
        ),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getUserName() {
    final user = video['user'];
    if (user is Map<String, dynamic>) {
      return user['username']?.toString() ?? 'unknown';
    }
    return 'unknown';
  }

  String _formatCount(dynamic count) {
    if (count == null) return '0';
    
    final num = int.tryParse(count.toString()) ?? 0;
    
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    } else {
      return num.toString();
    }
  }
}