// lib/widgets/lainnya_menu_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LainnyaMenuModal extends StatelessWidget {
  const LainnyaMenuModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                const Icon(Icons.tiktok, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Lainnya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  icon: Icons.search,
                  title: 'Dapatkan Koin',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Buat efek TikTok',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.create,
                  title: 'Alat kreator',
                  hasArrow: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.language,
                  title: 'Bahasa Indonesia',
                  hasArrow: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.dark_mode,
                  title: 'Mode gelap',
                  hasArrow: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.help,
                  title: 'Umpan balik dan bantuan',
                  showBadge: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Keluar',
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasArrow = false,
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Stack(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                if (showBadge)
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Keluar dari akun',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close modal
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show the modal
void showLainnyaMenu(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Lainnya Menu',
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: const LainnyaMenuModal(),
          ),
        ),
      );
    },
  );
}