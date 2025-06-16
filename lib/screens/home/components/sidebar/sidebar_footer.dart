// lib/screens/home/components/sidebar/sidebar_footer.dart  
import 'package:flutter/material.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
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