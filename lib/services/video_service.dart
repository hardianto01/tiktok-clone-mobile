// lib/services/video_service.dart - FIXED VERSION
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';



import 'package:flutter/foundation.dart';
import 'api_service.dart';


class VideoService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Changed from localhost

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<bool> uploadVideo({
    required File videoFile,
    File? thumbnailFile,
    required String title,
    required String description,
    required int categoryId,
    required List<String> hashtags,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Starting upload with token: ${token.substring(0, 10)}...');
      print('Video file path: ${videoFile.path}');
      print('Video file exists: ${await videoFile.exists()}');

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/videos'));
      
      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add form fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category_id'] = categoryId.toString();
      
      if (hashtags.isNotEmpty) {
        request.fields['hashtags'] = hashtags.join(',');
      }

      // Add video file with proper content type
      final videoBytes = await videoFile.readAsBytes();
      final videoMimeType = lookupMimeType(videoFile.path) ?? 'video/mp4';
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'video',
          videoBytes,
          filename: videoFile.path.split('/').last,
          contentType: MediaType.parse(videoMimeType),
        ),
      );

      print('Video file size: ${videoBytes.length} bytes');
      print('Video MIME type: $videoMimeType');

      // Add thumbnail file if provided
      if (thumbnailFile != null && await thumbnailFile.exists()) {
        final thumbnailBytes = await thumbnailFile.readAsBytes();
        final thumbnailMimeType = lookupMimeType(thumbnailFile.path) ?? 'image/jpeg';
        
        request.files.add(
          http.MultipartFile.fromBytes(
            'thumbnail',
            thumbnailBytes,
            filename: thumbnailFile.path.split('/').last,
            contentType: MediaType.parse(thumbnailMimeType),
          ),
        );
        print('Thumbnail added: ${thumbnailFile.path.split('/').last}');
      }

      print('Sending request to: ${request.url}');
      print('Request fields: ${request.fields}');

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response data: $responseData');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Upload successful!');
        return true;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print('Error response: $responseData');
        
        // Try to parse error message
        try {
          final errorData = jsonDecode(responseData);
          if (errorData['message'] != null) {
            throw Exception('Server error: ${errorData['message']}');
          }
          if (errorData['errors'] != null) {
            throw Exception('Validation errors: ${errorData['errors']}');
          }
        } catch (e) {
          // If JSON parsing fails, throw the raw response
          throw Exception('Upload failed: $responseData');
        }
        
        return false;
      }
    } catch (e) {
      print('Error uploading video: $e');
      rethrow; // Re-throw to show specific error in UI
    }
  }

  // Rest of the methods remain the same...
  static Future<List<Map<String, dynamic>>> getVideos({
    String? category,
    int page = 1,
  }) async {
    try {
      String url = '$baseUrl/videos?page=$page';
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? data);
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }

  static Future<bool> likeVideo(int videoId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/like'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error liking video: $e');
      return false;
    }
  }

  static Future<bool> uploadVideoBytes({
  required Uint8List videoBytes,
  required String fileName,
  required String title,
  required String description,
  required int categoryId,
  required List<String> hashtags,
}) async {
  try {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token');

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/videos'));
    
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category_id'] = categoryId.toString();
    if (hashtags.isNotEmpty) {
      request.fields['hashtags'] = hashtags.join(',');
    }

    request.files.add(http.MultipartFile.fromBytes(
      'video',
      videoBytes,
      filename: fileName,
    ));

    final response = await request.send();
    return response.statusCode == 201 || response.statusCode == 200;
  } catch (e) {
    print('Upload error: $e');
    return false;
  }
}
}

