import 'package:flutter/material.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyVideos = List.generate(20, (index) => {
      'title': 'Video ${index + 1}',
      'username': 'user_${index + 1}',
    });
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: dummyVideos.length,
      itemBuilder: (context, index) => _buildVideoCard(dummyVideos[index]),
    );
  }

  Widget _buildVideoCard(Map<String, String> video) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.purple.withOpacity(0.4), Colors.blue.withOpacity(0.4)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
            ),
          ),
          Positioned(
            bottom: 12, left: 12, right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video['title']!, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('@${video['username']}', 
                  style: TextStyle(color: Colors.grey[300], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}