// lib/screens/home/components/topbar/topbar_widget.dart
import 'package:flutter/material.dart';
import '../../../../widgets/app_icon_widgets.dart';

class TopbarWidget extends StatelessWidget {
  final String title;
  final bool showSearch;

  const TopbarWidget({
    super.key,
    required this.title,
    this.showSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16, right: 16, bottom: 8
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            )
          ),
          
          const Spacer(),
          
          if (showSearch)
            const AppSearchBar(
              hintText: 'Cari di TikTok',
              width: 300,
            ),
        ],
      ),
    );
  }
}