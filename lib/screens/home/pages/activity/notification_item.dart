// lib/screens/home/pages/activity/widgets/notification_item.dart
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final Widget avatar;
  final String title;
  final String subtitle;
  final String time;
  final Widget? thumbnail;
  final bool hasRedDot;

  const NotificationItem({
    super.key,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.time,
    this.thumbnail,
    this.hasRedDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            avatar,
            if (hasRedDot)
              Positioned(
                top: 0,
                right: 0,
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasRedDot)
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' $subtitle',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              if (hasRedDot)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        if (thumbnail != null) ...[
          const SizedBox(width: 8),
          thumbnail!,
        ],
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 16,
        ),
      ],
    );
  }
}