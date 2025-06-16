// lib/widgets/media_content_widget.dart
import 'package:flutter/material.dart';
import '../constants/app_icons.dart';

class MediaContentWidget extends StatelessWidget {
  final Map<String, dynamic> media;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showPlayButton;
  final bool showControls;
  final VoidCallback? onTap;

  const MediaContentWidget({
    super.key,
    required this.media,
    this.width,
    this.height,
    this.borderRadius,
    this.showPlayButton = true,
    this.showControls = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = _isVideoContent(media);
    final mediaUrl = _getMediaUrl(media);
    final thumbnailUrl = _getThumbnailUrl(media);

    return GestureDetector(
      onTap: onTap ?? () => _openMediaViewer(context, isVideo),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          color: Colors.grey[900],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildMediaPreview(thumbnailUrl ?? mediaUrl, isVideo),
              if (isVideo && showPlayButton) _buildPlayButton(),
              if (showControls) _buildMediaInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String? url, bool isVideo) {
    if (url == null || url.isEmpty) {
      return _buildPlaceholder(isVideo);
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isVideo),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator();
      },
    );
  }

  Widget _buildPlaceholder(bool isVideo) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(
          isVideo ? Icons.videocam : Icons.image,
          size: 60,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.play_circle_fill,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMediaInfo() {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (media['title'] != null)
              Text(
                media['title'],
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
                if (media['user'] != null) ...[
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey[600],
                    backgroundImage: media['user']['profile_image'] != null
                        ? NetworkImage(media['user']['profile_image'])
                        : null,
                    child: media['user']['profile_image'] == null
                        ? const Icon(Icons.person, size: 10, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '@${media['user']['username'] ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const Spacer(),
                if (media['views_count'] != null) ...[
                  Icon(Icons.visibility, size: 12, color: Colors.white70),
                  const SizedBox(width: 2),
                  Text(
                    _formatCount(media['views_count']),
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
      ),
    );
  }

  bool _isVideoContent(Map<String, dynamic> content) {
    // Check if it has video_url
    if (content['video_url'] != null) {
      final url = content['video_url'] as String;
      return _isVideoUrl(url);
    }
    
    // Check file type from category or other indicators
    if (content['category'] != null) {
      final category = content['category']['name']?.toLowerCase() ?? '';
      if (category.contains('video') || category.contains('lipsync') || 
          category.contains('menyanyi') || category.contains('menari')) {
        return true;
      }
    }
    
    // Check content type from media metadata
    if (content['content_type'] != null) {
      return content['content_type'].toString().startsWith('video/');
    }
    
    // Default to checking file extension
    final mediaUrl = _getMediaUrl(content);
    return _isVideoUrl(mediaUrl);
  }

  bool _isVideoUrl(String? url) {
    if (url == null) return false;
    
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v', '.3gp'];
    final lowerUrl = url.toLowerCase();
    
    return videoExtensions.any((ext) => lowerUrl.contains(ext));
  }

  String? _getMediaUrl(Map<String, dynamic> content) {
    return content['video_url'] ?? 
           content['image_url'] ?? 
           content['media_url'] ?? 
           content['file_url'];
  }

  String? _getThumbnailUrl(Map<String, dynamic> content) {
    return content['thumbnail_url'] ?? content['preview_url'];
  }

  void _openMediaViewer(BuildContext context, bool isVideo) {
    if (isVideo) {
      // Navigate to video player
      Navigator.pushNamed(context, '/video_player', arguments: media);
    } else {
      // Navigate to image viewer  
      Navigator.pushNamed(context, '/image_viewer', arguments: media);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}