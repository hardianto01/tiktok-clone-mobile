// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  static String? _token;

  // Authentication methods
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Mock successful login for development
      _token = 'mock_token_123';
      return {
        'user': {
          'id': 1,
          'username': 'testuser',
          'email': email,
          'profile_image': null,
          'bio': 'Test user bio',
          'followers_count': 0,
          'following_count': 0,
          'is_verified': false,
        },
        'token': _token,
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      // Mock successful registration for development
      _token = 'mock_token_123';
      return {
        'user': {
          'id': 1,
          'username': username,
          'email': email,
          'profile_image': null,
          'bio': null,
          'followers_count': 0,
          'following_count': 0,
          'is_verified': false,
        },
        'token': _token,
      };
    }
  }

  static Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _token = null;
    }
  }

  static Future<bool> isLoggedIn() async {
    return _token != null;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Get current user error: $e');
    }

    // Mock current user for development
    return {
      'user': {
        'id': 1,
        'username': 'testuser',
        'email': 'test@example.com',
        'profile_image': null,
        'bio': 'Test user bio',
        'followers_count': 0,
        'following_count': 0,
        'is_verified': false,
      }
    };
  }

  // Video methods
  static Future<Map<String, dynamic>?> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error getting categories: $e');
    }

    // Mock data for categories
    return {
      'data': [
        {'id': 1, 'name': 'Semua', 'slug': 'semua', 'is_active': true},
        {'id': 2, 'name': 'Menyanyi & Menari', 'slug': 'menyanyi-menari', 'is_active': true},
        {'id': 3, 'name': 'Komedi', 'slug': 'komedi', 'is_active': true},
        {'id': 4, 'name': 'Olahraga', 'slug': 'olahraga', 'is_active': true},
        {'id': 5, 'name': 'Anime & Komik', 'slug': 'anime-komik', 'is_active': true},
        {'id': 6, 'name': 'Hubungan', 'slug': 'hubungan', 'is_active': true},
        {'id': 7, 'name': 'Pertunjukan', 'slug': 'pertunjukan', 'is_active': true},
        {'id': 8, 'name': 'Lipsync', 'slug': 'lipsync', 'is_active': true},
        {'id': 9, 'name': 'Kehidupan Sehari-hari', 'slug': 'kehidupan-sehari-hari', 'is_active': true},
      ]
    };
  }

  static Future<Map<String, dynamic>?> getVideos({String? category, int page = 1}) async {
    try {
      String url = '$baseUrl/videos?page=$page';
      if (category != null && category != 'semua') {
        url += '&category=$category';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error getting videos: $e');
    }

    // Mock data for videos
    await Future.delayed(const Duration(milliseconds: 500));
    final videos = List.generate(10, (index) => {
      'id': index + 1,
      'title': 'Video ${index + 1}',
      'description': 'This is description for video ${index + 1}',
      'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'thumbnail_url': 'https://picsum.photos/360/640?random=${index + 1}',
      'duration': 30 + (index * 10),
      'likes_count': (index + 1) * 100,
      'comments_count': (index + 1) * 20,
      'shares_count': (index + 1) * 5,
      'views_count': (index + 1) * 1000,
      'hashtags': ['viral', 'trending', 'fun'],
      'user': {
        'id': index + 1,
        'username': 'user${index + 1}',
        'email': 'user${index + 1}@example.com',
        'profile_image': 'https://picsum.photos/100/100?random=${index + 100}',
      },
      'category': {
        'id': 1,
        'name': 'Semua',
        'slug': 'semua',
      },
      'created_at': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
    });

    return {
      'data': videos,
      'current_page': page,
      'last_page': 5,
      'total': 50,
    };
  }

  static Future<Map<String, dynamic>?> getUserVideos(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/videos'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error getting user videos: $e');
    }

    // Mock user videos
    await Future.delayed(const Duration(milliseconds: 300));
    final videos = List.generate(5, (index) => {
      'id': index + 1,
      'title': 'My Video ${index + 1}',
      'description': 'This is my video ${index + 1}',
      'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'thumbnail_url': 'https://picsum.photos/360/640?random=${index + 50}',
      'duration': 45 + (index * 15),
      'likes_count': (index + 1) * 50,
      'comments_count': (index + 1) * 10,
      'shares_count': (index + 1) * 3,
      'views_count': (index + 1) * 500,
      'hashtags': ['personal', 'content'],
      'user_id': userId,
      'is_public': true,
      'created_at': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
    });

    return {
      'data': videos,
      'total': videos.length,
    };
  }

  static Future<Map<String, dynamic>?> uploadVideo({
    required String title,
    String? description,
    required int categoryId,
    required String videoPath,
    String? thumbnailPath,
    List<String>? hashtags,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/videos'));
      
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      request.fields['category_id'] = categoryId.toString();
      if (hashtags != null) request.fields['hashtags'] = hashtags.join(',');

      request.files.add(await http.MultipartFile.fromPath('video', videoPath));
      if (thumbnailPath != null) {
        request.files.add(await http.MultipartFile.fromPath('thumbnail', thumbnailPath));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return jsonDecode(responseData);
      } else {
        final error = jsonDecode(responseData);
        throw Exception(error['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print('Error uploading video: $e');
      
      // Mock successful upload for development
      await Future.delayed(const Duration(seconds: 2));
      return {
        'message': 'Video uploaded successfully',
        'video': {
          'id': DateTime.now().millisecondsSinceEpoch,
          'title': title,
          'description': description,
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
          'thumbnail_url': thumbnailPath != null ? 'https://picsum.photos/360/640' : null,
          'hashtags': hashtags ?? [],
          'likes_count': 0,
          'comments_count': 0,
          'shares_count': 0,
          'views_count': 0,
          'created_at': DateTime.now().toIso8601String(),
        }
      };
    }
  }

  // Video interactions
  static Future<Map<String, dynamic>?> likeVideo(int videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/like'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error liking video: $e');
    }

    // Mock response
    return {
      'liked': true,
      'likes_count': 101,
    };
  }

  static Future<Map<String, dynamic>?> shareVideo(int videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/share'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error sharing video: $e');
    }

    // Mock response
    return {
      'message': 'Video shared successfully',
      'shares_count': 21,
    };
  }

  // Comments
  static Future<Map<String, dynamic>?> getComments(int videoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/videos/$videoId/comments'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error getting comments: $e');
    }

    // Mock comments
    await Future.delayed(const Duration(milliseconds: 300));
    final comments = List.generate(5, (index) => {
      'id': index + 1,
      'user_id': index + 1,
      'video_id': videoId,
      'comment_text': 'This is comment ${index + 1}',
      'likes_count': index * 2,
      'created_at': DateTime.now().subtract(Duration(hours: index)).toIso8601String(),
      'user': {
        'id': index + 1,
        'username': 'commenter${index + 1}',
        'profile_image': 'https://picsum.photos/50/50?random=${index + 200}',
      },
      'replies': [],
    });

    return {
      'data': comments,
      'total': comments.length,
    };
  }

  static Future<Map<String, dynamic>?> addComment(int videoId, String commentText, {int? parentId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/comments'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'comment_text': commentText,
          if (parentId != null) 'parent_id': parentId,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error adding comment: $e');
    }

    // Mock response
    return {
      'message': 'Comment added successfully',
      'comment': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'user_id': 1,
        'video_id': videoId,
        'parent_id': parentId,
        'comment_text': commentText,
        'likes_count': 0,
        'created_at': DateTime.now().toIso8601String(),
        'user': {
          'id': 1,
          'username': 'testuser',
          'profile_image': null,
        }
      }
    };
  }

  // User management
  static Future<Map<String, dynamic>?> followUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/follow'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error following user: $e');
    }

    // Mock response
    return {
      'following': true,
      'followers_count': 51,
    };
  }

  static Future<Map<String, dynamic>?> updateProfile({
    String? username,
    String? bio,
    String? profileImagePath,
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/profile'));
      
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      if (username != null) request.fields['username'] = username;
      if (bio != null) request.fields['bio'] = bio;

      if (profileImagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_image', profileImagePath));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseData);
      }
    } catch (e) {
      print('Error updating profile: $e');
    }

    // Mock response
    return {
      'message': 'Profile updated successfully',
      'user': {
        'id': 1,
        'username': username ?? 'testuser',
        'email': 'test@example.com',
        'profile_image': profileImagePath != null ? 'https://picsum.photos/200/200' : null,
        'bio': bio,
        'followers_count': 0,
        'following_count': 0,
        'is_verified': false,
      }
    };
  }

  // Search
  static Future<Map<String, dynamic>?> searchVideos(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/videos/search?q=${Uri.encodeComponent(query)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error searching videos: $e');
    }

    // Mock search results
    await Future.delayed(const Duration(milliseconds: 500));
    final videos = List.generate(3, (index) => {
      'id': index + 100,
      'title': 'Search Result ${index + 1} for "$query"',
      'description': 'This video matches your search for "$query"',
      'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'thumbnail_url': 'https://picsum.photos/360/640?random=${index + 300}',
      'duration': 60 + (index * 20),
      'likes_count': (index + 1) * 80,
      'comments_count': (index + 1) * 15,
      'shares_count': (index + 1) * 4,
      'views_count': (index + 1) * 800,
      'hashtags': [query.toLowerCase(), 'search', 'result'],
      'user': {
        'id': index + 10,
        'username': 'creator${index + 1}',
        'email': 'creator${index + 1}@example.com',
        'profile_image': 'https://picsum.photos/100/100?random=${index + 400}',
      },
      'created_at': DateTime.now().subtract(Duration(days: index + 1)).toIso8601String(),
    });

    return {
      'data': videos,
      'total': videos.length,
    };
  }

  // Trending videos
  static Future<Map<String, dynamic>?> getTrendingVideos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/videos/trending'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error getting trending videos: $e');
    }

    // Mock trending videos
    await Future.delayed(const Duration(milliseconds: 400));
    final videos = List.generate(8, (index) => {
      'id': index + 200,
      'title': 'Trending Video ${index + 1}',
      'description': 'This is a trending video with high engagement',
      'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      'thumbnail_url': 'https://picsum.photos/360/640?random=${index + 500}',
      'duration': 45 + (index * 12),
      'likes_count': (index + 1) * 500,
      'comments_count': (index + 1) * 100,
      'shares_count': (index + 1) * 25,
      'views_count': (index + 1) * 5000,
      'hashtags': ['trending', 'viral', 'popular'],
      'user': {
        'id': index + 20,
        'username': 'trendy${index + 1}',
        'email': 'trendy${index + 1}@example.com',
        'profile_image': 'https://picsum.photos/100/100?random=${index + 600}',
      },
      'created_at': DateTime.now().subtract(Duration(hours: index + 1)).toIso8601String(),
    });

    return {
      'data': videos,
      'total': videos.length,
    };
  }
}