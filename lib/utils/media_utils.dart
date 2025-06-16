// lib/utils/media_utils.dart
import 'dart:io';
import 'package:flutter/foundation.dart';

class MediaUtils {
  // Video file extensions
  static const List<String> videoExtensions = [
    '.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v', '.3gp', '.flv', '.wmv'
  ];
  
  // Image file extensions
  static const List<String> imageExtensions = [
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.tiff', '.svg'
  ];
  
  // Video MIME types
  static const List<String> videoMimeTypes = [
    'video/mp4', 'video/quicktime', 'video/x-msvideo', 'video/x-matroska',
    'video/webm', 'video/3gpp', 'video/x-flv', 'video/x-ms-wmv'
  ];
  
  // Image MIME types
  static const List<String> imageMimeTypes = [
    'image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/webp',
    'image/tiff', 'image/svg+xml'
  ];

  /// Check if the given URL or file path is a video
  static bool isVideo(String? url) {
    if (url == null || url.isEmpty) return false;
    
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.contains(ext));
  }

  /// Check if the given URL or file path is an image
  static bool isImage(String? url) {
    if (url == null || url.isEmpty) return false;
    
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.contains(ext));
  }

  /// Check if the given MIME type is a video
  static bool isVideoMimeType(String? mimeType) {
    if (mimeType == null || mimeType.isEmpty) return false;
    
    return videoMimeTypes.any((type) => mimeType.toLowerCase().startsWith(type));
  }

  /// Check if the given MIME type is an image
  static bool isImageMimeType(String? mimeType) {
    if (mimeType == null || mimeType.isEmpty) return false;
    
    return imageMimeTypes.any((type) => mimeType.toLowerCase().startsWith(type));
  }

  /// Determine media type from a content object
  static MediaType getMediaType(Map<String, dynamic> content) {
    // Check by MIME type first
    final mimeType = content['content_type'] ?? content['mime_type'];
    if (mimeType != null) {
      if (isVideoMimeType(mimeType)) return MediaType.video;
      if (isImageMimeType(mimeType)) return MediaType.image;
    }
    
    // Check by URL
    final videoUrl = content['video_url'];
    if (videoUrl != null && isVideo(videoUrl)) {
      return MediaType.video;
    }
    
    final imageUrl = content['image_url'] ?? content['photo_url'];
    if (imageUrl != null && isImage(imageUrl)) {
      return MediaType.image;
    }
    
    // Check by file path
    final filePath = content['file_path'] ?? content['path'];
    if (filePath != null) {
      if (isVideo(filePath)) return MediaType.video;
      if (isImage(filePath)) return MediaType.image;
    }
    
    // Check by category or other indicators
    final category = content['category'];
    if (category != null) {
      final categoryName = category['name']?.toLowerCase() ?? category.toString().toLowerCase();
      if (categoryName.contains('video') || categoryName.contains('lipsync') || 
          categoryName.contains('menyanyi') || categoryName.contains('menari')) {
        return MediaType.video;
      }
      if (categoryName.contains('photo') || categoryName.contains('image') || 
          categoryName.contains('picture')) {
        return MediaType.image;
      }
    }
    
    // Default to unknown
    return MediaType.unknown;
  }

  /// Get the best media URL from content object
  static String? getMediaUrl(Map<String, dynamic> content) {
    return content['video_url'] ?? 
           content['image_url'] ?? 
           content['photo_url'] ?? 
           content['media_url'] ?? 
           content['file_url'] ??
           content['url'];
  }

  /// Get thumbnail URL from content object
  static String? getThumbnailUrl(Map<String, dynamic> content) {
    return content['thumbnail_url'] ?? 
           content['preview_url'] ?? 
           content['thumb_url'] ??
           getMediaUrl(content); // Fallback to main media URL
  }

  /// Format file size to human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration to human readable format
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  /// Format count numbers (likes, views, etc.)
  static String formatCount(int count) {
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  /// Get file extension from URL or path
  static String? getFileExtension(String? url) {
    if (url == null || url.isEmpty) return null;
    
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? url;
    final lastDot = path.lastIndexOf('.');
    
    if (lastDot == -1) return null;
    return path.substring(lastDot).toLowerCase();
  }

  /// Check if the file is supported for upload
  static bool isSupportedFile(String? path) {
    if (path == null) return false;
    return isVideo(path) || isImage(path);
  }

  /// Validate file size for upload
  static bool isValidFileSize(int bytes, {int maxSizeInMB = 50}) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return bytes <= maxSizeInBytes;
  }

  /// Get media info summary
  static Map<String, dynamic> getMediaInfo(Map<String, dynamic> content) {
    final mediaType = getMediaType(content);
    final mediaUrl = getMediaUrl(content);
    final thumbnailUrl = getThumbnailUrl(content);
    
    return {
      'type': mediaType,
      'url': mediaUrl,
      'thumbnail': thumbnailUrl,
      'isVideo': mediaType == MediaType.video,
      'isImage': mediaType == MediaType.image,
      'title': content['title'],
      'description': content['description'],
      'user': content['user'],
      'stats': {
        'views': content['views_count'] ?? 0,
        'likes': content['likes_count'] ?? 0,
        'comments': content['comments_count'] ?? 0,
        'shares': content['shares_count'] ?? 0,
      },
    };
  }
}

/// Enum for media types
enum MediaType {
  video,
  image,
  unknown,
}

/// Extension methods for MediaType
extension MediaTypeExtension on MediaType {
  String get name {
    switch (this) {
      case MediaType.video:
        return 'Video';
      case MediaType.image:
        return 'Image';
      case MediaType.unknown:
        return 'Unknown';
    }
  }
  
  String get icon {
    switch (this) {
      case MediaType.video:
        return '🎥';
      case MediaType.image:
        return '🖼️';
      case MediaType.unknown:
        return '❓';
    }
  }
}

/// File validation helper
class FileValidator {
  static const int maxVideoSizeMB = 50;
  static const int maxImageSizeMB = 10;
  static const Duration maxVideoDuration = Duration(minutes: 10);
  
  static ValidationResult validateFile(File file, MediaType type) {
    final fileSize = file.lengthSync();
    
    switch (type) {
      case MediaType.video:
        if (fileSize > maxVideoSizeMB * 1024 * 1024) {
          return ValidationResult.error('Video file too large. Max size: ${maxVideoSizeMB}MB');
        }
        break;
        
      case MediaType.image:
        if (fileSize > maxImageSizeMB * 1024 * 1024) {
          return ValidationResult.error('Image file too large. Max size: ${maxImageSizeMB}MB');
        }
        break;
        
      case MediaType.unknown:
        return ValidationResult.error('Unsupported file type');
    }
    
    return ValidationResult.success();
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  const ValidationResult._(this.isValid, this.errorMessage);
  
  factory ValidationResult.success() => const ValidationResult._(true, null);
  factory ValidationResult.error(String message) => ValidationResult._(false, message);
}