// lib/widgets/video_player_widget.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.autoPlay = true,
    this.showControls = true,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      
      await _controller!.initialize();
      
      if (widget.autoPlay) {
        await _controller!.play();
        _isPlaying = true;
      }
      
      _controller!.addListener(_videoListener);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller?.value.isPlaying ?? false;
      });
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_hasError || _controller == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Error loading video',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializePlayer,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.showControls ? _toggleControls : null,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),

            // Controls overlay
            if (widget.showControls && _showControls)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top controls
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                // More options
                              },
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Center play/pause button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Bottom controls
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Progress bar
                            VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Time and controls
                            Row(
                              children: [
                                Text(
                                  _formatDuration(_controller!.value.position),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                const Text(
                                  ' / ',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  _formatDuration(_controller!.value.duration),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                
                                const Spacer(),
                                
                                // Volume control
                                IconButton(
                                  onPressed: () {
                                    final volume = _controller!.value.volume > 0 ? 0.0 : 1.0;
                                    _controller!.setVolume(volume);
                                  },
                                  icon: Icon(
                                    _controller!.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                                    color: Colors.white,
                                  ),
                                ),
                                
                                // Fullscreen toggle
                                IconButton(
                                  onPressed: () {
                                    // Toggle fullscreen
                                  },
                                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}