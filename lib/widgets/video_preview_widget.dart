// lib/screens/upload/widgets/video_preview_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';

class VideoPreviewWidget extends StatelessWidget {
  final File? selectedVideo;
  final Uint8List? selectedVideoBytes;
  final String? selectedVideoName;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const VideoPreviewWidget({
    super.key,
    this.selectedVideo,
    this.selectedVideoBytes,
    this.selectedVideoName,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasVideo = kIsWeb ? selectedVideoBytes != null : selectedVideo != null;
    final videoName = kIsWeb ? selectedVideoName : selectedVideo?.path.split('/').last;

    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: !hasVideo
          ? InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text('Tap to select video', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('MP4, MOV, AVI (Max 50MB)', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[800],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
                        const SizedBox(height: 8),
                        const Text('Video Selected', style: TextStyle(color: Colors.white)),
                        if (videoName != null)
                          Text(videoName,
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                              textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onClear,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Change', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}