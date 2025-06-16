// lib/config/api_config.dart
import 'package:flutter/foundation.dart';

class ApiConfig {
  // 🔧 Base URLs - Ganti sesuai hosting yang dipakai
  static const String _developmentUrl = 'https://drian-backend.is-web.my.id/api';
  static const String _productionUrl = 'https://drian-backend.is-web.my.id/api';
  
  // Auto switch berdasarkan mode (debug/release)
  static String get baseUrl => kDebugMode ? _developmentUrl : _productionUrl;
  
  // 🌐 Authentication Endpoints
  static String get loginUrl => '$baseUrl/login';
  static String get registerUrl => '$baseUrl/register';
  static String get logoutUrl => '$baseUrl/logout';
  static String get meUrl => '$baseUrl/me';
  
  // 🎥 Video Endpoints
  static String get videosUrl => '$baseUrl/videos';
  static String get trendingUrl => '$baseUrl/videos/trending';
  static String get searchUrl => '$baseUrl/videos/search';
  static String videoDetailUrl(int id) => '$baseUrl/videos/$id';
  static String videoLikeUrl(int id) => '$baseUrl/videos/$id/like';
  static String videoShareUrl(int id) => '$baseUrl/videos/$id/share';
  static String videoDeleteUrl(int id) => '$baseUrl/videos/$id';
  
  // 💬 Comment Endpoints
  static String videoCommentsUrl(int videoId) => '$baseUrl/videos/$videoId/comments';
  static String addCommentUrl(int videoId) => '$baseUrl/videos/$videoId/comments';
  
  // 👥 User Endpoints
  static String userProfileUrl(int id) => '$baseUrl/users/$id';
  static String userVideosUrl(int id) => '$baseUrl/users/$id/videos';
  static String followUserUrl(int id) => '$baseUrl/users/$id/follow';
  static String get updateProfileUrl => '$baseUrl/profile';
  
  // 📂 Category Endpoints
  static String get categoriesUrl => '$baseUrl/categories';
  
  // 🔧 Configuration
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // 📱 App Info
  static const String appVersion = '1.0.0';
  static const String appName = 'TikTok Clone';
  
  // 🎯 Debugging
  static void printCurrentConfig() {
    if (kDebugMode) {
      print('🔧 API Configuration:');
      print('   Mode: ${kDebugMode ? "Development" : "Production"}');
      print('   Base URL: $baseUrl');
      print('   Timeout: ${timeoutDuration.inSeconds}s');
    }
  }
}

// 🌍 Environment-specific configurations
class Environment {
  static const String development = 'development';
  static const String production = 'production';
  
  static String get current => kDebugMode ? development : production;
  
  static bool get isDevelopment => current == development;
  static bool get isProduction => current == production;
}
