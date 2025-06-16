// lib/models/user_model.dart
class User {
  final int id;
  final String username;
  final String email;
  final String? emailVerifiedAt;
  final String? profileImage;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.emailVerifiedAt,
    this.profileImage,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'profile_image': profileImage,
      'bio': bio,
      'followers_count': followersCount,
      'following_count': followingCount,
      'is_verified': isVerified,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  // Getter untuk kompatibilitas dengan format snake_case
  bool get is_verified => isVerified;
}