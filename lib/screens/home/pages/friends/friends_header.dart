// lib/screens/home/pages/friends/friends_header.dart
import 'package:flutter/material.dart';

class FriendsHeader extends StatelessWidget {
  const FriendsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Temukan teman di TikTok', 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18, 
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 8),
          Text('Cari kreator yang kamu kenal', 
            style: TextStyle(
              color: Colors.grey[400], 
              fontSize: 14
            )
          ),
        ],
      ),
    );
  }
}