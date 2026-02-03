import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import 'story_skeleton.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String? caption;
  final String? author;
  final List<String>? hashtags;
  final VideoPlayerController? externalController;
  final bool isCurrent;
  final VoidCallback? onReadMore;

  const VideoPlayerWidget({
    super.key,
    required this.url,
    this.caption,
    this.author,
    this.hashtags,
    this.externalController,
    this.isCurrent = false,
    this.onReadMore,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isLocalController = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.externalController != null) {
      _controller = widget.externalController;
      _isLocalController = false;
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      _isLocalController = true;
    }

    if (_controller!.value.isInitialized) {
      _onControllerInitialized();
    } else {
      _controller!.initialize().then((_) {
        if (mounted) _onControllerInitialized();
      });
      // Also listen for initialization if it happens externally
      _controller!.addListener(_initializationListener);
    }
  }

  void _initializationListener() {
    if (_controller != null && _controller!.value.isInitialized && !_initialized) {
      _controller!.removeListener(_initializationListener);
      if (mounted) _onControllerInitialized();
    }
  }

  void _onControllerInitialized() {
    setState(() {
      _initialized = true;
      _controller!.setLooping(true);
      if (widget.isCurrent) {
        _controller!.play();
      }
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null && _initialized) {
      if (widget.isCurrent && !oldWidget.isCurrent) {
        _controller!.play();
      } else if (!widget.isCurrent && oldWidget.isCurrent) {
        _controller!.pause();
      }
    }
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _controller?.dispose();
    } else {
      _controller?.removeListener(_initializationListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Layer
        GestureDetector(
          onTap: () {
            if (_controller == null || !_initialized) return;
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: _initialized && _controller != null
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                )
              : const StorySkeleton(),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(51), // 0.2 * 255
                Colors.transparent,
                Colors.black.withAlpha(153), // 0.6 * 255
              ],
            ),
          ),
        ),

        // Info Layer (Glassmorphic)
        Positioned(
          bottom: 110, // Adjusted for floating navbar
          left: 20,
          right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.author != null)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppTheme.accent.withAlpha(127),
                            child: Text(
                              widget.author![0].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.author!,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    if (widget.caption != null)
                      Text(
                        widget.caption!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: 1.4,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 12),
                    if (widget.hashtags != null && widget.hashtags!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: widget.hashtags!.map((h) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withAlpha(51),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#$h',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.accentSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        )).toList(),
                      ),
                    
                    if (widget.onReadMore != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: widget.onReadMore,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Read More',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.accent),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Play/Pause Icon Overlay
        if (_initialized && _controller != null && !_controller!.value.isPlaying)
           const Center(
             child: Icon(Icons.play_circle_outline, size: 64, color: AppTheme.accent),
           ),
      ],
    );
  }
}
