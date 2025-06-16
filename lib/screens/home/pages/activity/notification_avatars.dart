// lib/screens/home/pages/activity/widgets/notification_avatars.dart
import 'package:flutter/material.dart';

class NotificationAvatars {
  static Widget buildSystemAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static Widget buildUserAvatar(String name, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget buildReportAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.flag,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static Widget buildVideoThumbnail() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}