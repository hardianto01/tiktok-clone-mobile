// lib/screens/home/pages/explore/category_tabs.dart
import 'package:flutter/material.dart';
import '../../../../models/category_model.dart';

class CategoryTabs extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<String> _defaultCategories = [
    'Semua', 'Menyanyi & Menari', 'Komedi', 'Olahraga', 'Anime & Komik',
    'Hubungan', 'Pertunjukan', 'Lipsync', 'Kehidupan Sehari-hari'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.isNotEmpty ? categories.length : _defaultCategories.length,
        itemBuilder: (context, index) {
          if (categories.isNotEmpty) {
            final category = categories[index];
            final isSelected = category.slug == selectedCategory;
            return GestureDetector(
              onTap: () => onCategorySelected(category.slug),
              child: _buildCategoryTab(category.name, isSelected),
            );
          } else {
            return _buildCategoryTab(_defaultCategories[index], index == 0);
          }
        },
      ),
    );
  }

  Widget _buildCategoryTab(String name, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey[600]!, width: 1),
      ),
      child: Center(
        child: Text(name, style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}