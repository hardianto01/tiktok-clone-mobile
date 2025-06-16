// lib/models/category.dart
class Category {
  final int id;
  final String name;
  final String slug;
  final String? icon;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'is_active': isActive,
    };
  }

  // For compatibility with existing code that expects Map access
  String operator [](String key) {
    switch (key) {
      case 'id':
        return id.toString();
      case 'name':
        return name;
      case 'slug':
        return slug;
      case 'icon':
        return icon ?? '';
      case 'is_active':
        return isActive.toString();
      default:
        return '';
    }
  }
}