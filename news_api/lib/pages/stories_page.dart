import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../widgets/story_card.dart';

class StoriesPage extends ConsumerWidget {
  final StoryType storyType;

  const StoriesPage({super.key, required this.storyType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider(storyType));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(storiesProvider(storyType));
      },
      child: storiesAsync.when(
        data: (stories) {
          if (stories.isEmpty) {
            return const Center(
              child: Text('No stories found'),
            );
          }

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return StoryCard(
                story: story,
                onTap: () {
                  // Navigate to story detail page using GoRouter
                  if (story.id != null) {
                    context.go('/story/${story.id}');
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load stories',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(storiesProvider(storyType));
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}