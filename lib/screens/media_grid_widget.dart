// lib/widgets/media_grid_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'media_content_widget.dart';

class MediaGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;
  final bool useStaggeredGrid;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const MediaGridWidget({
    super.key,
    required this.mediaList,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.useStaggeredGrid = false,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) {
      return _buildEmptyState();
    }

    return useStaggeredGrid ? _buildStaggeredGrid() : _buildRegularGrid();
  }

  Widget _buildEmptyState() {
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
            'No media found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your first photo or video',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularGrid() {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 9 / 16, // TikTok-like aspect ratio
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        return MediaContentWidget(
          media: mediaList[index],
          borderRadius: BorderRadius.circular(8),
        );
      },
    );
  }

  Widget _buildStaggeredGrid() {
    return MasonryGridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        return MediaContentWidget(
          media: mediaList[index],
          height: _getRandomHeight(index),
          borderRadius: BorderRadius.circular(8),
        );
      },
    );
  }

  double _getRandomHeight(int index) {
    // Generate different heights for masonry layout
    final heights = [200.0, 250.0, 180.0, 300.0, 220.0, 280.0];
    return heights[index % heights.length];
  }
}

class MediaListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const MediaListWidget({
    super.key,
    required this.mediaList,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: mediaList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return MediaContentWidget(
          media: media,
          height: 400,
          borderRadius: BorderRadius.circular(12),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No content found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class MediaCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;
  final double height;
  final EdgeInsets? padding;

  const MediaCarouselWidget({
    super.key,
    required this.mediaList,
    this.height = 200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: mediaList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: height * 9 / 16, // Maintain aspect ratio
            child: MediaContentWidget(
              media: mediaList[index],
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
}