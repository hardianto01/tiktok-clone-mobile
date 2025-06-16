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
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'],
      isActive: json['is_active'] ?? true,
    );
  }
}