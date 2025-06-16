// lib/screens/image_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../constants/app_icons.dart';
import '../widgets/app_icon_widgets.dart';

class ImageViewerScreen extends StatefulWidget {
  final Map<String, dynamic> image;
  final List<Map<String, dynamic>>? gallery;
  final int? currentIndex;

  const ImageViewerScreen({
    super.key,
    required this.image,
    this.gallery,
    this.currentIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  int _currentIndex = 0;
  bool _showControls = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    
    _fadeController.forward();
    
    // Auto hide controls
    _autoHideControls();
  }

  void _autoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _autoHideControls();
    }
  }

  Map<String, dynamic> get _currentImage {
    if (widget.gallery != null && widget.gallery!.isNotEmpty) {
      return widget.gallery![_currentIndex];
    }
    return widget.image;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Image gallery or single image
            _buildImageContent(),
            
            // Controls overlay
            if (_showControls) _buildControlsOverlay(),
            
            // Image info overlay
            _buildImageInfo(),
            
            // Action buttons
            _buildActionButtons(),
            
            // Page indicator (for gallery)
            if (widget.gallery != null && widget.gallery!.length > 1)
              _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: widget.gallery != null && widget.gallery!.length > 1
            ? _buildImageGallery()
            : _buildSingleImage(),
      ),
    );
  }

  Widget _buildImageGallery() {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        final image = widget.gallery![index];
        return PhotoViewGalleryPageOptions(
          imageProvider: _getImageProvider(image),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          errorBuilder: (context, error, stackTrace) => _buildErrorState(),
        );
      },
      itemCount: widget.gallery!.length,
      loadingBuilder: (context, event) => _buildLoadingState(),
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      pageController: _pageController,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
      },
    );
  }

  Widget _buildSingleImage() {
    return PhotoView(
      imageProvider: _getImageProvider(_currentImage),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2.0,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      loadingBuilder: (context, event) => _buildLoadingState(),
      errorBuilder: (context, error, stackTrace) => _buildErrorState(),
    );
  }

  ImageProvider _getImageProvider(Map<String, dynamic> image) {
    final imageUrl = image['image_url'] ?? image['thumbnail_url'] ?? image['video_url'];
    
    if (imageUrl == null) {
      throw Exception('Image URL not found');
    }
    
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Cannot load image',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'The image might be corrupted or unavailable',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.red),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          // Top controls
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Spacer(),
                if (widget.gallery != null && widget.gallery!.length > 1)
                  Text(
                    '${_currentIndex + 1} / ${widget.gallery!.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.grey[800],
                  onSelected: (value) {
                    switch (value) {
                      case 'save':
                        _saveImage();
                        break;
                      case 'share':
                        _shareImage();
                        break;
                      case 'report':
                        _reportImage();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'save',
                      child: Row(
                        children: [
                          Icon(Icons.download, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Save', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Share', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.report, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Report', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageInfo() {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[600],
                backgroundImage: _currentImage['user']?['profile_image'] != null
                    ? NetworkImage(_currentImage['user']['profile_image'])
                    : null,
                child: _currentImage['user']?['profile_image'] == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${_currentImage['user']?['username'] ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_currentImage['title'] != null)
                      Text(
                        _currentImage['title'],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          if (_currentImage['description'] != null)
            Text(
              _currentImage['description'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          
          const SizedBox(height: 8),
          
          // Hashtags
          if (_currentImage['hashtags'] != null)
            Wrap(
              children: (_currentImage['hashtags'] as List)
                  .map((hashtag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '#$hashtag',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          ActionButton(
            icon: AppIcons.like,
            count: _formatCount(_currentImage['likes_count'] ?? 0),
            onPressed: () {
              // Handle like
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.comment,
            count: _formatCount(_currentImage['comments_count'] ?? 0),
            onPressed: () {
              // Handle comment
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.share,
            count: _formatCount(_currentImage['shares_count'] ?? 0),
            onPressed: () {
              // Handle share
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.bookmark,
            count: '',
            onPressed: () {
              // Handle bookmark
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.gallery!.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentIndex
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _saveImage() {
    // Implement save to gallery functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image saved to gallery'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareImage() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _reportImage() {
    // Implement report functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Report Content', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Do you want to report this content?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Content reported'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}