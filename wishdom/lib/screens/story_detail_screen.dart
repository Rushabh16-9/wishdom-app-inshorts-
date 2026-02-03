import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import '../theme/app_theme.dart';

class StoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> storyData;

  const StoryDetailScreen({super.key, required this.storyData});

  @override
  Widget build(BuildContext context) {
    // If it's a text story, show the full "Reading Mode" view
    if (storyData['type'] == 'text') {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    // Optional: Share or other actions
                  ],
                ),
              ),
              // Scrollable Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                  children: [
                    Text(
                      storyData['author'] ?? 'Anonymous', // Using author as title based on previous mapping or title field if exists
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      storyData['textContent'] ?? '',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        height: 1.6,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: Icon(Icons.check_circle_outline, 
                        color: AppTheme.textSecondary.withAlpha(50), 
                        size: 32
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default (Video): Show the Story Card with Back Button overlay
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // The Story Card itself
          StoryCard(
            storyData: storyData,
            isCurrent: true, // Auto-play video
          ),
          
          // Back Button Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withAlpha(102),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
