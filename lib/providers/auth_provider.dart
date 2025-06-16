// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';

class User {
  final int id;
  final String username;
  final String email;
  final String? profileImage;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isVerified = false,
  });

  bool get is_verified => isVerified;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      bio: json['bio'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await ApiService.login(email, password);
      if (response['user'] != null) {
        _user = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await ApiService.register(
        username: username,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      
      if (response['user'] != null) {
        _user = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await ApiService.isLoggedIn();
      if (isLoggedIn) {
        final response = await ApiService.getCurrentUser();
        if (response != null && response['user'] != null) {
          _user = User.fromJson(response['user']);
          notifyListeners();
        }
      }
    } catch (e) {
      _user = null;
      notifyListeners();
    }
  }
}