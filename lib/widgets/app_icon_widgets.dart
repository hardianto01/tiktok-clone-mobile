// lib/widgets/app_icon_widgets.dart - Fixed SearchBar naming conflict
import 'package:flutter/material.dart';
import '../constants/app_icons.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final bool isActive;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? 
      (isActive ? AppIconColors.active : AppIconColors.primary);
    
    return IconButton(
      icon: Icon(icon, color: iconColor, size: size ?? AppIconSizes.normal),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}

class NavigationIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBadge;
  final Color? badgeColor;

  const NavigationIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isSelected ? AppIconColors.active : AppIconColors.inactive,
                size: AppIconSizes.normal,
              ),
              if (showBadge)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: badgeColor ?? AppIconColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppIconColors.active : AppIconColors.inactive,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

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
              color: iconColor ?? (isSelected ? AppIconColors.active : AppIconColors.primary),
              size: AppIconSizes.medium,
            ),
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppIconColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? (isSelected ? AppIconColors.active : AppIconColors.primary),
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

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isActive;

  const ActionButton({
    super.key,
    required this.icon,
    required this.count,
    this.iconColor = Colors.white,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? AppIconColors.like : iconColor,
              size: AppIconSizes.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomUploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;

  const CustomUploadButton({
    super.key,
    required this.onPressed,
    this.gradientColors,
    this.width = 45,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ?? [Colors.red, Colors.pink],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          AppIcons.add,
          color: Colors.white,
          size: AppIconSizes.medium,
        ),
      ),
    );
  }
}

class TikTokLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconSize;

  const TikTokLogo({
    super.key,
    this.width = 32,
    this.height = 32,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.black, Colors.black]),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        AppIcons.music,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}

// Renamed to avoid conflict with Flutter's SearchBar
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const AppSearchBar({
    super.key,
    this.hintText = 'Cari',
    this.width,
    this.height = 36,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(AppIcons.search, color: Colors.grey[400], size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

// For backward compatibility, create an alias
typedef SearchBar = AppSearchBar;