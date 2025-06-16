// lib/screens/home/pages/activity/activity_page.dart
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _showNotificationPanel = false;

  final List<String> _tabs = [
    'Semua aktivitas',
    'Suka',
    'Komentar',
    'Sebutan dan tanda',
    'Pengikut'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    
    // Auto show notification panel when activity page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showNotificationPanel = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content area
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Halaman Aktivitas\n\nNotifikasi akan muncul sebagai overlay',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Notification panel overlay
          if (_showNotificationPanel) _buildNotificationOverlay(),
        ],
      ),
    );
  }

  Widget _buildNotificationOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          width: 450,
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!, width: 1),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              _buildFollowRequestSection(),
              Expanded(child: _buildActivityList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Notifikasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showNotificationPanel = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedTabIndex;
          return GestureDetector(
            onTap: () {
              _tabController.animateTo(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey[600]!,
                  width: 1,
                ),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFollowRequestSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Permintaan mengikuti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            '19',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Baru'),
          const SizedBox(height: 12),
          _buildNotificationItem(
            avatar: _buildSystemAvatar(),
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
                _buildNotificationItem(
                  avatar: _buildUserAvatar('Cal', Colors.orange),
                  title: 'Cal',
                  subtitle: 'menyukai video yang Anda posting ulang. 5-4',
                  time: '',
                  thumbnail: _buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  avatar: _buildUserAvatar('aois', Colors.grey),
                  title: 'aois',
                  subtitle: 'menyukai video yang Anda posting ulang. 4-27',
                  time: '',
                  thumbnail: _buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  avatar: _buildReportAvatar(),
                  title: 'Laporan: Lihat status laporan Anda.',
                  subtitle: '4-6',
                  time: '',
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  avatar: _buildUserAvatar('sooo', Colors.grey),
                  title: 'sooo',
                  subtitle: 'menyebut Anda dalam komentar: @aojis @Sakatonik @Δ ⚡ @driaaaan_17 @andyahmad ini kak 2-21',
                  time: '',
                  thumbnail: _buildVideoThumbnail(),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  avatar: _buildUserAvatar('Cal', Colors.orange),
                  title: 'Cal',
                  subtitle: 'menyukai video yang Anda posting ulang.',
                  time: '',
                  thumbnail: _buildVideoThumbnail(),
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

  Widget _buildNotificationItem({
    required Widget avatar,
    required String title,
    required String subtitle,
    required String time,
    Widget? thumbnail,
    bool hasRedDot = false,
  }) {
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
          thumbnail,
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

  Widget _buildSystemAvatar() {
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

  Widget _buildUserAvatar(String name, Color color) {
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

  Widget _buildReportAvatar() {
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

  Widget _buildVideoThumbnail() {
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}