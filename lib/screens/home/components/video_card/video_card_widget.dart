// lib/screens/home/components/video_card/video_card_widget.dart
import 'package:flutter/material.dart';
import '../../../../constants/app_icons.dart';

class VideoCardWidget extends StatelessWidget {
  final int index;

  const VideoCardWidget({
    super.key,
    required this.index,
  });

  static const List<double> _heights = [280.0, 320.0, 300.0, 360.0, 290.0, 340.0, 310.0, 330.0];
  static const List<String> _users = ['sasl_4giril', 'jadenibo', 'ag.sadin', 'bukhary.ismail', 'user_'];
  static const List<String> _views = ['3M', '2.7M', '1.2M', '419.8K', '100K'];
  static const List<String> _descriptions = [
    'Video lucu banget 😂 #viral #comedy',
    'Tutorial dance keren! #dance #trending',
    'Moment epic hari ini #lifestyle',
    'Behind the scenes #bts #content',
    'Skill gila abis 🔥 #talent #amazing'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _heights[index % _heights.length],
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            _buildVideoBackground(),
            _buildOverlay(),
            _buildLikeCount(),
            _buildBottomContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(128, 0, 128, 0.4),
            Color.fromRGBO(0, 0, 255, 0.4),
            Color.fromRGBO(255, 192, 203, 0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(AppIcons.play, 
          color: Colors.white.withValues(alpha: 0.8), 
          size: AppIconSizes.xlarge),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeCount() {
    return Positioned(
      top: 12, right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.like, color: AppIconColors.like, size: 12),
            const SizedBox(width: 4),
            Text(_views[index % _views.length], 
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 12, 
                fontWeight: FontWeight.bold
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Positioned(
      left: 12, right: 12, bottom: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _descriptions[index % _descriptions.length],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[600],
                child: const Icon(AppIcons.profile, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_users[index % _users.length]}${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}