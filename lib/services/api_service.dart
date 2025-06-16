// lib/services/api_service.dart - Updated Version
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class ApiService {
  static String? _authToken;

  // Initialize API service
  static void initialize() {
    ApiConfig.printCurrentConfig();
  }

  // Set auth token
  static void setAuthToken(String token) {
    _authToken = token;
    if (kDebugMode) print('🔑 Auth token set');
  }

  // Clear auth token
  static void clearAuthToken() {
    _authToken = null;
    if (kDebugMode) print('🔑 Auth token cleared');
  }

  // Get headers with auth
  static Map<String, String> _getHeaders({bool isMultipart = false}) {
    final headers = <String, String>{
      if (!isMultipart) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': '${ApiConfig.appName}/${ApiConfig.appVersion}',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Handle API response
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    try {
      if (kDebugMode) {
        print('📡 API Response: ${response.statusCode} - ${response.request?.url}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {'success': true};
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print('❌ API Error ${response.statusCode}: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error parsing response: $e');
      return null;
    }
  }

  // Authentication Methods
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: _getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.timeoutDuration);
      
      final result = _handleResponse(response);
      if (result != null && result['token'] != null) {
        setAuthToken(result['token']);
      }
      
      return result;
    } catch (e) {
      if (kDebugMode) print('❌ Login error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: _getHeaders(),
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(ApiConfig.timeoutDuration);
      
      final result = _handleResponse(response);
      if (result != null && result['token'] != null) {
        setAuthToken(result['token']);
      }
      
      return result;
    } catch (e) {
      if (kDebugMode) print('❌ Register error: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse(ApiConfig.logoutUrl),
        headers: _getHeaders(),
      ).timeout(ApiConfig.timeoutDuration);
    } catch (e) {
      if (kDebugMode) print('❌ Logout error: $e');
    } finally {
      clearAuthToken();
    }
  }

  // Video Methods
  static Future<Map<String, dynamic>?> getVideos({
    String? category,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
      };
      
      if (category != null && category != 'semua') {
        queryParams['category'] = category;
      }
      
      final uri = Uri.parse(ApiConfig.videosUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _getHeaders()).timeout(ApiConfig.timeoutDuration);
      
      final result = _handleResponse(response);
      
      // Fix video URLs if they exist
      if (result != null && result['data'] != null) {
        final videos = result['data'] as List;
        for (var video in videos) {
          if (video['video_url'] != null) {
            video['video_url'] = _fixMediaUrl(video['video_url']);
          }
          if (video['thumbnail_url'] != null) {
            video['thumbnail_url'] = _fixMediaUrl(video['thumbnail_url']);
          }
        }
      }
      
      return result;
    } catch (e) {
      if (kDebugMode) print('❌ Get videos error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.categoriesUrl),
        headers: _getHeaders(),
      ).timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('❌ Get categories error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> searchVideos(String query) async {
    try {
      final uri = Uri.parse(ApiConfig.searchUrl).replace(
        queryParameters: {'q': query},
      );
      
      final response = await http.get(uri, headers: _getHeaders()).timeout(ApiConfig.timeoutDuration);
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('❌ Search videos error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> toggleVideoLike(int videoId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.videoLikeUrl(videoId)),
        headers: _getHeaders(),
      ).timeout(ApiConfig.timeoutDuration);
      
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('❌ Toggle like error: $e');
      return null;
    }
  }

  // Helper method to fix media URLs
  static String _fixMediaUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    if (url.startsWith('http')) {
      return url; // Already absolute URL
    }
    
    // Remove leading slash if present
    String cleanUrl = url.startsWith('/') ? url.substring(1) : url;
    
    // Ensure it starts with storage/
    if (!cleanUrl.startsWith('storage/')) {
      if (cleanUrl.startsWith('app/public/')) {
        cleanUrl = cleanUrl.replaceFirst('app/public/', 'storage/');
      } else {
        cleanUrl = 'storage/$cleanUrl';
      }
    }
    
    // Get base URL without /api
    String baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl/$cleanUrl';
  }
}
