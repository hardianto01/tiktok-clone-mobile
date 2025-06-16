import '../models/user_model.dart' as user_model;
import '../models/category_model.dart' as category_model;

class Video {
  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int duration;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isPublic;
  final List<String> hashtags;
  final DateTime createdAt;
  final user_model.User? user;
  final category_model.Category? category;
  final bool isLiked;

  Video({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.viewsCount,
    required this.isPublic,
    required this.hashtags,
    required this.createdAt,
    this.user,
    this.category,
    this.isLiked = false,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      duration: json['duration'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      isPublic: json['is_public'] ?? true,
      hashtags: json['hashtags'] != null 
          ? List<String>.from(json['hashtags'])
          : [],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? user_model.User.fromJson(json['user']) : null,
      category: json['category'] != null ? category_model.Category.fromJson(json['category']) : null,
      isLiked: json['is_liked'] ?? false,
    );
  }

  Video copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? duration,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isPublic,
    List<String>? hashtags,
    DateTime? createdAt,
    user_model.User? user,
    category_model.Category? category,
    bool? isLiked,
  }) {
    return Video(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isPublic: isPublic ?? this.isPublic,
      hashtags: hashtags ?? this.hashtags,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      category: category ?? this.category,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}