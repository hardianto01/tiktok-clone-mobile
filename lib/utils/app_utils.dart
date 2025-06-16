// lib/utils/app_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';

enum HapticFeedbackType { light, medium, heavy, selection }

class AppUtils {
  /// Format numbers to human readable format (1.2K, 3.4M, etc.)
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

  /// Format duration to human readable format (1:23, 12:34, 1:12:34)
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

  /// Format file size to human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format time ago (2m ago, 1h ago, 1d ago)
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return '1d ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w ago';
      if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo ago';
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[0-9]{10,13}$').hasMatch(phone.replaceAll(RegExp(r'[^\d]'), ''));
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
           RegExp(r'[A-Z]').hasMatch(password) &&
           RegExp(r'[a-z]').hasMatch(password) &&
           RegExp(r'[0-9]').hasMatch(password);
  }

  /// Generate random color
  static Color generateRandomColor() {
    final random = math.Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  /// Get contrast color (black or white) for given background
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Haptic feedback
  static void hapticFeedback({HapticFeedbackType type = HapticFeedbackType.light}) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  /// Show snackbar with custom styling
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.grey[800],
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Debounce function calls
  static Timer? _debounceTimer;
  static void debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Copy text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Get platform type
  static bool get isWeb => kIsWeb;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  /// Get responsive breakpoints
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// Get grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  /// Safe area insets
  static EdgeInsets getSafeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Keyboard height
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return getKeyboardHeight(context) > 0;
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Convert hex color to Color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Convert Color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Generate avatar placeholder
  static Widget generateAvatarPlaceholder({
    String? text,
    double size = 40,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final bgColor = backgroundColor ?? generateRandomColor();
    final txtColor = textColor ?? getContrastColor(bgColor);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text?.isNotEmpty == true ? text![0].toUpperCase() : '?',
          style: TextStyle(
            color: txtColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Generate random username
  static String generateRandomUsername() {
    final random = math.Random();
    final adjectives = ['Cool', 'Super', 'Amazing', 'Epic', 'Pro', 'Mega', 'Ultra', 'Fast'];
    final nouns = ['User', 'Player', 'Creator', 'Star', 'Hero', 'Master', 'Ninja', 'Legend'];
    final number = random.nextInt(999) + 1;
    
    return '${adjectives[random.nextInt(adjectives.length)]}${nouns[random.nextInt(nouns.length)]}$number';
  }

  /// Validate username
  static bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username);
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Get file extension
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Check if file is video
  static bool isVideoFile(String fileName) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'webm'];
    return videoExtensions.contains(getFileExtension(fileName));
  }

  /// Check if file is image
  static bool isImageFile(String fileName) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(getFileExtension(fileName));
  }

  /// Generate random hashtags
  static List<String> generateRandomHashtags({int count = 3}) {
    final hashtags = ['viral', 'trending', 'fun', 'cool', 'amazing', 'epic', 'awesome', 'best', 'new', 'hot'];
    final random = math.Random();
    final result = <String>[];
    
    for (int i = 0; i < count && i < hashtags.length; i++) {
      final tag = hashtags[random.nextInt(hashtags.length)];
      if (!result.contains(tag)) {
        result.add(tag);
      }
    }
    
    return result;
  }

  /// Parse hashtags from text
  static List<String> parseHashtags(String text) {
    final regex = RegExp(r'#([a-zA-Z0-9_]+)');
    return regex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.red),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Get random video duration
  static Duration getRandomVideoDuration() {
    final random = math.Random();
    final seconds = random.nextInt(180) + 15; // 15-195 seconds
    return Duration(seconds: seconds);
  }

  /// Get random view count
  static int getRandomViewCount() {
    final random = math.Random();
    final multiplier = random.nextInt(4);
    
    switch (multiplier) {
      case 0: return random.nextInt(1000); // 0-999
      case 1: return random.nextInt(100) * 1000; // 0-99K
      case 2: return random.nextInt(10) * 100000; // 0-999K
      default: return random.nextInt(10) * 1000000; // 0-9M
    }
  }

  /// Generate mock video data
  static Map<String, dynamic> generateMockVideo(int index) {
    final random = math.Random(index); // Consistent random for same index
    final usernames = ['user_$index', 'creator_$index', 'star_$index'];
    final descriptions = [
      'Amazing video! #viral #trending',
      'Check this out 🔥 #fyp #amazing',
      'So cool! #fun #awesome',
      'Incredible moment #epic #wow',
      'Must watch! #trending #cool'
    ];

    return {
      'id': index,
      'username': usernames[random.nextInt(usernames.length)],
      'description': descriptions[random.nextInt(descriptions.length)],
      'viewCount': getRandomViewCount(),
      'likeCount': random.nextInt(50000),
      'commentCount': random.nextInt(1000),
      'shareCount': random.nextInt(500),
      'duration': getRandomVideoDuration(),
      'hashtags': generateRandomHashtags(count: random.nextInt(3) + 1),
      'isLiked': random.nextBool(),
      'isFollowing': random.nextBool(),
    };
  }
}