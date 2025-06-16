// lib/screens/home/pages/activity/widgets/activity_list.dart
import 'package:flutter/material.dart';
import 'notification_item.dart';
import 'notification_avatars.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Baru'),
          const SizedBox(height: 12),
          NotificationItem(
            avatar: NotificationAvatars.buildSystemAvatar(),
            title: 'Notifikasi Sistem',
            subtitle: 'LIVE: Yuk rayakan momen Idul Adha penuh makna...',
            time: '',
            hasRedDot: true,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Sebelumnya'),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                NotificationItem(
                  avatar: NotificationAvatars.buildUserAvatar('Cal', Colors.orange),
                  title: 'Cal',
                  subtitle: 'menyukai video yang Anda posting ulang. 5-4',
                  time: '',
                  thumbnail: NotificationAvatars.buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                NotificationItem(
                  avatar: NotificationAvatars.buildUserAvatar('aois', Colors.grey),
                  title: 'aois',
                  subtitle: 'menyukai video yang Anda posting ulang. 4-27',
                  time: '',
                  thumbnail: NotificationAvatars.buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                NotificationItem(
                  avatar: NotificationAvatars.buildReportAvatar(),
                  title: 'Laporan: Lihat status laporan Anda.',
                  subtitle: '4-6',
                  time: '',
                ),
                const SizedBox(height: 16),
                NotificationItem(
                  avatar: NotificationAvatars.buildUserAvatar('sooo', Colors.grey),
                  title: 'sooo',
                  subtitle: 'menyebut Anda dalam komentar: @aojis @Sakatonik @Δ ⚡ @driaaaan_17 @andyahmad ini kak 2-21',
                  time: '',
                  thumbnail: NotificationAvatars.buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                NotificationItem(
                  avatar: NotificationAvatars.buildUserAvatar('Cal', Colors.orange),
                  title: 'Cal',
                  subtitle: 'menyukai video yang Anda posting ulang.',
                  time: '',
                  thumbnail: NotificationAvatars.buildVideoThumbnail(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}