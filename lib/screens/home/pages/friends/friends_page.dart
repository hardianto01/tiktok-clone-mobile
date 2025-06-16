// lib/screens/home/pages/friends/friends_page.dart
import 'package:flutter/material.dart';
import 'friends_header.dart';
import 'friend_card.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          const FriendsHeader(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 12,
                itemBuilder: (context, index) => FriendCard(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}