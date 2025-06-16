// lib/widgets/bottom_navigation.dart - Updated with icon structure
import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../widgets/app_icon_widgets.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Bottom navigation items configuration
  static const List<Map<String, dynamic>> _navItems = [
    {
      'icon': AppIcons.homeOutlined,
      'label': 'Beranda',
      'index': 0,
    },
    {
      'icon': AppIcons.search,
      'label': 'Temukan',
      'index': 1,
    },
    {
      'icon': AppIcons.upload, // This will be replaced with custom upload button
      'label': '',
      'index': 2,
      'isUpload': true,
    },
    {
      'icon': AppIcons.messages,
      'label': 'Inbox',
      'index': 3,
    },
    {
      'icon': AppIcons.profile,
      'label': 'Profil',
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.map((item) {
          if (item['isUpload'] == true) {
            return CustomUploadButton(
              onPressed: () => onTap(item['index']),
            );
          }
          
          return NavigationIcon(
            icon: item['icon'],
            label: item['label'],
            isSelected: currentIndex == item['index'],
            onTap: () => onTap(item['index']),
          );
        }).toList(),
      ),
    );
  }
}