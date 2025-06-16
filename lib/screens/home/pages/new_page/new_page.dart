// lib/screens/home/pages/new_page/new_page.dart
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text('New Page Content', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
