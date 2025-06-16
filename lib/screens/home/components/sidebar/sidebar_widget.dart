// lib/screens/home/components/sidebar/sidebar_widget.dart
import 'package:flutter/material.dart';
import '../../../../constants/app_icons.dart';
import '../../../../widgets/app_icon_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart'; 
import '../../../../widgets/lainnya_menu_modal.dart';

class SidebarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const SidebarWidget({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  static const List<Map<String, dynamic>> _menuItems = [
  {'icon': Icons.home, 'title': 'Saran', 'index': 0},
  {'icon': Icons.explore, 'title': 'Jelajahi', 'index': 1},
  {'icon': Icons.people, 'title': 'Mengikuti', 'index': 2},
  {'icon': Icons.group, 'title': 'Teman', 'index': 3},
  {'icon': Icons.add, 'title': 'Unggah', 'index': 4, 'action': 'upload'},
  {'icon': Icons.notifications, 'title': 'Aktivitas', 'index': 5, 'showBadge': true},
  {'icon': Icons.message, 'title': 'Pesan', 'index': 6},
  {'icon': Icons.videocam, 'title': 'LIVE', 'index': 7},
  {'icon': Icons.person, 'title': 'Profil', 'index': 8},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.black,
      child: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildMenuItems(context),
          _buildLoginButton(context),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20, right: 20, bottom: 20,
      ),
      child: const Row(
        children: [
          TikTokLogo(),
          SizedBox(width: 12),
          Text('TikTok', 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: const AppSearchBar(
        hintText: 'Cari',
        width: double.infinity,
        height: 40,
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: _menuItems.length + 1,
        separatorBuilder: (context, index) {
          if (index == _menuItems.length - 1) {
            return Divider(color: Colors.grey[800], height: 32);
          }
          return const SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          if (index == _menuItems.length) {
            return SidebarMenuItem(
              icon: AppIcons.more,
              title: 'Lainnya',
              isSelected: false,
              onTap: () => showLainnyaMenu(context), // FIXED!
            );
          }

          final item = _menuItems[index];
          return SidebarMenuItem(
            icon: item['icon'],
            title: item['title'],
            isSelected: currentIndex == item['index'],
            onTap: () {
              if (item['action'] == 'upload') {
                Navigator.pushNamed(context, '/upload');
              } else {
                onItemSelected(item['index']);
              }
            },
            iconColor: item['iconColor'],
            titleColor: item['titleColor'],
            showBadge: item['showBadge'] ?? false,
          );
        },
      ),
    );
  }

    Widget _buildLoginButton(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isAuthenticated
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat datang,", 
                    style: TextStyle(color: Colors.white, fontSize: 14)
                  ),
                  Text(
                    "${authProvider.user?.username ?? 'User'}",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppIconColors.active,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('Log masuk', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                ),
              );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perusahaan', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text('Program', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text('Ketentuan & Kebijakan', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 8),
          Text('© 2025 TikTok', style: TextStyle(color: Colors.grey[700], fontSize: 11)),
        ],
      ),
    );
  }
}