// lib/screens/home/components/sidebar/sidebar_menu_item.dart
import 'package:flutter/material.dart';

class SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final bool showBadge;

  const SidebarMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Stack(
          children: [
            Icon(
              icon,
              color: iconColor ?? (isSelected ? Colors.red : Colors.white),
              size: 24,
            ),
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? (isSelected ? Colors.red : Colors.white),
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        dense: true,
        tileColor: isSelected ? Colors.grey[900] : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}