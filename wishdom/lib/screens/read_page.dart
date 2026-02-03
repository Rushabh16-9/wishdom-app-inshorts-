import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReadPage extends StatelessWidget {
  final Map<String, dynamic> storyData;

  const ReadPage({super.key, required this.storyData});

  @override
  Widget build(BuildContext context) {
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
                    storyData['author'] ?? 'Anonymous',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    storyData['textContent'] ?? storyData['caption'] ?? '',
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
}
