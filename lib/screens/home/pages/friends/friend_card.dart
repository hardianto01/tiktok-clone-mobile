// lib/screens/home/pages/friends/friend_card.dart
import 'package:flutter/material.dart';
import '../../../../constants/app_icons.dart';

class FriendCard extends StatelessWidget {
  final int index;

  const FriendCard({
    super.key,
    required this.index,
  });

  static const List<String> _names = [
    'RaffiNagita1717', 'Ayu Ting Ting', 'prilly latuconsina', 'sarwendahofficial',
    'Natasha Wilona', 'JDID', 'Ria Ricis', 'Awkarin', 'Rachel Vennya',
    'Nagita Slavina', 'Luna Maya', 'Syahrini'
  ];
  
  static const List<String> _usernames = [
    'raffi_nagita1717', 'ayutingting92', 'prillylatuconsina15', 'sarwendahofficial',
    'natashawilona12', 'jdidofficial', 'riaricis1795', 'awkarin', 'rachelvennya',
    'gigihadid', 'lunamaya26', 'princessyahrini'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildProfileSection(),
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 192, 203, 0.3),
              Color.fromRGBO(128, 0, 128, 0.3),
              Color.fromRGBO(0, 0, 255, 0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[700],
                child: const Icon(AppIcons.profile, size: 30, color: Colors.white),
              ),
            ),
            if (index < 6)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppIconColors.verified,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(AppIcons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(_names[index],
              style: const TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
                fontSize: 12
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('@${_usernames[index]}',
              style: TextStyle(
                color: Colors.grey[400], 
                fontSize: 10
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 28,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppIconColors.active,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Ikuti',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 12, 
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}