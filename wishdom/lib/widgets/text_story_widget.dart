import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class TextStoryWidget extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback? onReadMore;

  const TextStoryWidget({
    super.key,
    required this.title,
    required this.content,
    this.onReadMore,
  });

  @override
  State<TextStoryWidget> createState() => _TextStoryWidgetState();
}

class _TextStoryWidgetState extends State<TextStoryWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _showReaderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false, // Critical: Prevent accidental drag-to-dismiss
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            // Header with Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hidden icon for alignment
                  const Icon(Icons.close, color: Colors.transparent),
                  // Drag Handle (Visual Indicator Only)
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Close Button
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
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
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.content,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
          // Background Pattern Layer
          Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              image: DecorationImage(
                image: const NetworkImage("https://www.transparenttextures.com/patterns/aged-paper.png"),
                colorFilter: ColorFilter.mode(Colors.black.withAlpha(51), BlendMode.dstATop),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          
          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Floating Title Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withAlpha(38)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 28,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.content,
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Interaction Hint
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100), // Adjusted for floating navbar
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withAlpha(51),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.accent.withAlpha(127)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'SWIPE LEFT TO READ',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_back, color: AppTheme.accent, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
