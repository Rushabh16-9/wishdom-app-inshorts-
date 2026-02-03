import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'text';
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController(); // Comma separated
  bool _isLoading = false;

  Future<void> _uploadStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final hashtags = _hashtagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final storyData = {
        'type': _type,
        'author': 'User', // Hardcoded for now
        'caption': _captionController.text,
        'hashtags': hashtags,
      };

      if (_type == 'video') {
        storyData['contentUrl'] = _contentController.text;
      } else {
        storyData['textContent'] = _contentController.text;
      }

      await ApiService.createStory(storyData);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Story'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selector
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: AppTheme.surface,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Story Type',
                  labelStyle: TextStyle(color: AppTheme.accent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent, width: 2)),
                ),
                items: const [
                  DropdownMenuItem(value: 'text', child: Text('Text Story')),
                  DropdownMenuItem(value: 'video', child: Text('Video Story')),
                ],
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 16),

              // Content Input
              TextFormField(
                controller: _contentController,
                style: const TextStyle(color: AppTheme.textPrimary),
                maxLines: _type == 'text' ? 4 : 1,
                decoration: InputDecoration(
                  labelText: _type == 'text' ? 'Message' : 'Video URL',
                  labelStyle: const TextStyle(color: AppTheme.accent),
                  hintText: _type == 'text' ? 'Share your wisdom...' : 'https://example.com/video.mp4',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withAlpha(128)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent, width: 2)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Caption Input
              TextFormField(
                controller: _captionController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Caption (Optional)',
                  labelStyle: TextStyle(color: AppTheme.accent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent, width: 2)),
                ),
              ),
              const SizedBox(height: 16),

              // Hashtags Input
              TextFormField(
                controller: _hashtagsController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Hashtags (comma separated)',
                  labelStyle: TextStyle(color: AppTheme.accent),
                  hintText: 'motivation, stoicism, daily',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withAlpha(128)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent, width: 2)),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppTheme.background)
                    : const Text('POST STORY', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
