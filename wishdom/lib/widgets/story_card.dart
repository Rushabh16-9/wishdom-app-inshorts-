import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_widget.dart';
import 'text_story_widget.dart';

class StoryCard extends StatelessWidget {
  final Map<String, dynamic> storyData;
  final VideoPlayerController? externalController;
  final bool isCurrent;

  const StoryCard({
    super.key, 
    required this.storyData, 
    this.externalController,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    if (storyData['type'] == 'video') {
      return VideoPlayerWidget(
        url: storyData['contentUrl'] ?? '',
        caption: storyData['caption'],
        author: storyData['author'],
        hashtags: (storyData['hashtags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
        externalController: externalController,
        isCurrent: isCurrent,
      );
    } else {
      return TextStoryWidget(
        title: storyData['author'] ?? 'Anonymous',
        content: storyData['textContent'] ?? '',
      );
    }
  }
}
