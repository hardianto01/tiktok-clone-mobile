// lib/providers/video_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';

class VideoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _videos = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _currentCategory = 'semua'; // Add current category tracking

  // Getters
  List<Map<String, dynamic>> get videos => _videos;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String get currentCategory => _currentCategory; // Add getter

  // Add setCategory method
  void setCategory(String category) {
    _currentCategory = category;
    loadVideos(category);
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final response = await ApiService.getCategories();
      if (response != null && response['data'] != null) {
        _categories = (response['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      } else {
        // Fallback categories if API fails
        _categories = [
          Category(id: 1, name: 'Semua', slug: 'semua'),
          Category(id: 2, name: 'Menyanyi & Menari', slug: 'menyanyi-menari'),
          Category(id: 3, name: 'Komedi', slug: 'komedi'),
          Category(id: 4, name: 'Olahraga', slug: 'olahraga'),
          Category(id: 5, name: 'Anime & Komik', slug: 'anime-komik'),
          Category(id: 6, name: 'Hubungan', slug: 'hubungan'),
          Category(id: 7, name: 'Pertunjukan', slug: 'pertunjukan'),
          Category(id: 8, name: 'Lipsync', slug: 'lipsync'),
          Category(id: 9, name: 'Kehidupan Sehari-hari', slug: 'kehidupan-sehari-hari'),
        ];
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback categories
      _categories = [
        Category(id: 1, name: 'Semua', slug: 'semua'),
        Category(id: 2, name: 'Menyanyi & Menari', slug: 'menyanyi-menari'),
        Category(id: 3, name: 'Komedi', slug: 'komedi'),
        Category(id: 4, name: 'Olahraga', slug: 'olahraga'),
        Category(id: 5, name: 'Anime & Komik', slug: 'anime-komik'),
        Category(id: 6, name: 'Hubungan', slug: 'hubungan'),
        Category(id: 7, name: 'Pertunjukan', slug: 'pertunjukan'),
        Category(id: 8, name: 'Lipsync', slug: 'lipsync'),
        Category(id: 9, name: 'Kehidupan Sehari-hari', slug: 'kehidupan-sehari-hari'),
      ];
    }
    notifyListeners();
  }

  // Load videos with category filter
  Future<void> loadVideos([String? category]) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    _currentPage = 1;
    _hasMoreData = true;
    
    if (category != null) {
      _currentCategory = category;
    }
    
    notifyListeners();

    try {
      final response = await ApiService.getVideos(
        category: category == 'semua' ? null : category, 
        page: _currentPage
      );
      
      if (response != null && response['data'] != null) {
        _videos = List<Map<String, dynamic>>.from(response['data']);
        _hasMoreData = response['data'].length >= 10; // Assuming 10 items per page
      } else {
        // Fallback dummy data for development
        _videos = _generateDummyVideos();
      }
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      // Show dummy data on error for development
      _videos = _generateDummyVideos();
      print('Error loading videos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate dummy videos for development/testing
  List<Map<String, dynamic>> _generateDummyVideos() {
    return List.generate(10, (index) => {
      'id': index + 1,
      'title': 'Sample Video ${index + 1}',
      'description': 'This is a sample video description for video ${index + 1}',
      'video_url': 'https://example.com/video${index + 1}.mp4',
      'thumbnail_url': 'https://picsum.photos/300/400?random=$index',
      'duration': 30 + (index * 10),
      'likes_count': (index + 1) * 100,
      'comments_count': (index + 1) * 25,
      'shares_count': (index + 1) * 10,
      'views_count': (index + 1) * 1000,
      'is_public': true,
      'hashtags': ['#sample', '#video', '#test'],
      'created_at': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      'user': {
        'id': index + 1,
        'username': 'user${index + 1}',
        'profile_image': 'https://picsum.photos/100/100?random=${index + 100}',
      },
      'category': {
        'id': (index % 3) + 1,
        'name': ['Komedi', 'Menyanyi & Menari', 'Olahraga'][index % 3],
        'slug': ['komedi', 'menyanyi-menari', 'olahraga'][index % 3],
      },
      'is_liked': index % 3 == 0,
    });
  }

  // Load more videos (pagination)
  Future<void> loadMoreVideos() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final response = await ApiService.getVideos(
        category: _currentCategory == 'semua' ? null : _currentCategory,
        page: _currentPage
      );
      
      if (response != null && response['data'] != null) {
        final newVideos = List<Map<String, dynamic>>.from(response['data']);
        _videos.addAll(newVideos);
        _hasMoreData = newVideos.length >= 10;
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      _currentPage--; // Revert page increment on error
      print('Error loading more videos: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Refresh videos
  Future<void> refreshVideos([String? category]) async {
    await loadVideos(category ?? _currentCategory);
  }

  // Clear videos
  void clearVideos() {
    _videos.clear();
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Like/Unlike video
  Future<void> toggleLike(int videoId) async {
    try {
      // Find video in list
      final videoIndex = _videos.indexWhere((v) => v['id'] == videoId);
      if (videoIndex != -1) {
        final video = _videos[videoIndex];
        final isLiked = video['is_liked'] ?? false;
        
        // Optimistic update
        _videos[videoIndex] = {
          ...video,
          'is_liked': !isLiked,
          'likes_count': (video['likes_count'] ?? 0) + (isLiked ? -1 : 1),
        };
        notifyListeners();

        // Make API call
        // await ApiService.toggleVideoLike(videoId);
      }
    } catch (e) {
      print('Error toggling like: $e');
      // Revert optimistic update on error
      loadVideos(_currentCategory);
    }
  }

  // Search videos
  Future<void> searchVideos(String query) async {
    if (query.isEmpty) {
      loadVideos(_currentCategory);
      return;
    }

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.searchVideos(query);
      if (response != null && response['data'] != null) {
        _videos = List<Map<String, dynamic>>.from(response['data']);
      } else {
        _videos = [];
      }
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _videos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}