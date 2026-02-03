import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../widgets/story_card.dart';
import 'story_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String, dynamic>>>? _searchResults;
  bool _isSearching = false;

  void _performSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      _isSearching = true;
      _searchResults = ApiService.getStories(search: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withAlpha(25)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for wisdom...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.accent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        setState(() { _isSearching = false; _searchResults = null; });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),
            ),

            // Content
            Expanded(
              child: _isSearching
                  ? FutureBuilder<List<Map<String, dynamic>>>(
                      future: _searchResults,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No results found.', style: Theme.of(context).textTheme.bodyLarge),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            // Simple list view for search results
                            // In a real app we might want a grid or reuse StoryCard in a specific way
                            // For now, let's just show a mini version or the full card. 
                            // Reusing StoryCard in a list might be heavy if they are videos.
                            // Let's just show a simple text summary.
                            final story = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryDetailScreen(storyData: story),
                                  ),
                                );
                              },
                              leading: Icon(
                                story['type'] == 'video' ? Icons.videocam : Icons.text_fields,
                                color: AppTheme.accent,
                              ),
                              title: Text(
                                story['caption'] ?? (story['type'] == 'text' ? story['textContent'] : 'Video Story'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                story['author'] ?? 'Anonymous',
                                style: TextStyle(color: AppTheme.textSecondary),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : _buildTrendingGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingGrid() {
    final categories = ['#stoicism', '#motivation', '#nature', '#philosophy', '#tech', '#art'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trending Topics', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((tag) => ActionChip(
              backgroundColor: AppTheme.surface,
              label: Text(tag, style: const TextStyle(color: AppTheme.accentSecondary)),
              onPressed: () => _performSearch(tag.replaceAll('#', '')),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
