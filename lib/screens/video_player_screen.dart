// lib/screens/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_icons.dart';
import '../widgets/app_icon_widgets.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> video;
  final List<Map<String, dynamic>>? playlist;
  final int? currentIndex;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    this.playlist,
    this.currentIndex,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isBuffering = false;
  bool _hasError = false;
  String? _errorMessage;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    
    _initializeVideo();
    _fadeController.forward();
  }

  Future<void> _initializeVideo() async {
    try {
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });

      final videoUrl = widget.video['video_url'] as String?;
      if (videoUrl == null || videoUrl.isEmpty) {
        throw Exception('Video URL not found');
      }

      // Handle both network and local file URLs
      if (videoUrl.startsWith('http')) {
        _controller = VideoPlayerController.network(videoUrl);
      } else {
        _controller = VideoPlayerController.asset(videoUrl);
      }

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _duration = _controller!.value.duration;
        });

        _controller!.addListener(_videoListener);
        _autoPlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;
    
    final controller = _controller!;
    setState(() {
      _position = controller.value.position;
      _isPlaying = controller.value.isPlaying;
      _isBuffering = controller.value.isBuffering;
    });

    // Auto hide controls when playing
    if (_isPlaying && _showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _autoPlay() {
    if (_controller != null && _isInitialized) {
      _controller!.play();
    }
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      setState(() {
        if (_isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _seek(Duration position) {
    _controller?.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Video player or error state
            _buildVideoContent(),
            
            // Controls overlay
            if (_showControls) _buildControlsOverlay(),
            
            // Loading indicator
            if (_isBuffering) _buildLoadingIndicator(),
            
            // Video info overlay
            _buildVideoInfo(),
            
            // Action buttons (like, comment, share)
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: _hasError
              ? _buildErrorState()
              : _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : _buildLoadingState(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 80, color: Colors.grey[600]),
        const SizedBox(height: 16),
        Text(
          'Cannot play video',
          style: TextStyle(color: Colors.grey[400], fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage ?? 'Unknown error occurred',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _initializeVideo,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'Loading video...',
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.red),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          // Top controls
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Toggle fullscreen or other actions
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Bottom controls (progress bar)
          if (_isInitialized) _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Spacer(),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.red,
              inactiveTrackColor: Colors.grey[600],
              thumbColor: Colors.red,
              overlayColor: Colors.red.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 2,
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0.0,
              onChanged: (value) {
                final position = Duration(
                  milliseconds: (value * _duration.inMilliseconds).round(),
                );
                _seek(position);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[600],
                backgroundImage: widget.video['user']?['profile_image'] != null
                    ? NetworkImage(widget.video['user']['profile_image'])
                    : null,
                child: widget.video['user']?['profile_image'] == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${widget.video['user']?['username'] ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.video['title'] != null)
                      Text(
                        widget.video['title'],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          if (widget.video['description'] != null)
            Text(
              widget.video['description'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          
          const SizedBox(height: 8),
          
          // Hashtags
          if (widget.video['hashtags'] != null)
            Wrap(
              children: (widget.video['hashtags'] as List)
                  .map((hashtag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '#$hashtag',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          ActionButton(
            icon: AppIcons.like,
            count: _formatCount(widget.video['likes_count'] ?? 0),
            onPressed: () {
              // Handle like
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.comment,
            count: _formatCount(widget.video['comments_count'] ?? 0),
            onPressed: () {
              // Handle comment
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.share,
            count: _formatCount(widget.video['shares_count'] ?? 0),
            onPressed: () {
              // Handle share
            },
          ),
          const SizedBox(height: 20),
          ActionButton(
            icon: AppIcons.bookmark,
            count: '',
            onPressed: () {
              // Handle bookmark
            },
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}