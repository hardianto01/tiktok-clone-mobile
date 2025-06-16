// lib/screens/upload/widgets/thumbnail_section_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';

class ThumbnailSectionWidget extends StatelessWidget {
  final File? selectedThumbnail;
  final Uint8List? selectedThumbnailBytes;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const ThumbnailSectionWidget({
    super.key,
    this.selectedThumbnail,
    this.selectedThumbnailBytes,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = kIsWeb ? selectedThumbnailBytes != null : selectedThumbnail != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thumbnail (Optional)',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: !hasThumbnail
              ? InkWell(
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text('Add Thumbnail', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: kIsWeb
                              ? MemoryImage(selectedThumbnailBytes!)
                              : FileImage(selectedThumbnail!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onClear,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}