import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widgets/story_card.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'upload_screen.dart';
import 'read_page.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<Map<String, dynamic>> _currentStories = [];
  final Map<int, VideoPlayerController> _videoControllers = {};
  Future<List<Map<String, dynamic>>>? _storiesFuture;

  @override
  void initState() {
    super.initState();
    _storiesFuture = ApiService.getStories();
  }

  void _preloadVideos(int index) {
    // Preload current + next 2 videos
    for (int i = index; i < index + 3 && i < _currentStories.length; i++) {
       final story = _currentStories[i];
       if (story['type'] == 'video' && !_videoControllers.containsKey(i)) {
         final url = story['contentUrl'] ?? '';
         if (url.isNotEmpty) {
           final controller = VideoPlayerController.networkUrl(Uri.parse(url));
           _videoControllers[i] = controller;
           controller.initialize().then((_) {
             if (mounted) setState(() {});
           });
         }
       }
    }

    // Dispose controllers that are far away (more than 5 items away)
    _videoControllers.removeWhere((i, controller) {
      if ((i - index).abs() > 5) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Immersive background
      body: Stack(
        children: [
          // Layer 1: Content Feed
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _storiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.accent));
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading feed.\nCheck connection.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _storiesFuture = ApiService.getStories();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.accent,
                            side: const BorderSide(color: AppTheme.accent),
                          ),
                          child: const Text('RETRY'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                 return Center(
                  child: Text(
                    'No stories found.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              final stories = snapshot.data!;
              _currentStories = stories; 
              
              return PageView.builder(
                scrollDirection: Axis.vertical, // Reverted to vertical
                controller: _pageController,
                itemCount: stories.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _preloadVideos(index);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      // Detect Swipe Right-to-Left (Negative Velocity)
                      if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
                        _navigateToReadPage(stories[index]);
                      }
                    },
                    child: StoryCard(
                      storyData: stories[index],
                      externalController: _videoControllers[index],
                      isCurrent: index == _currentIndex,
                    ),
                  );
                },
              );
            },
          ),
          
          // Layer 2: Top Progress Indicators (Removed)
        ],
      ),
    );
  }

  void _navigateToReadPage(Map<String, dynamic> story) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ReadPage(storyData: story),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
