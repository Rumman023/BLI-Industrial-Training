// ignore_for_file: deprecated_member_use_from_same_package

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/news_service.dart';
// favorites removed
import '../models/news_format.dart';

part 'providers.g.dart';


enum StoryType {
  top('topstories'),
  newStories('newstories'), 
  best('beststories');

  const StoryType(this.apiPath);
  final String apiPath;

  String get displayName {
    switch (this) {
      case StoryType.top:
        return 'Top Stories';
      case StoryType.newStories:
        return 'New Stories';
      case StoryType.best:
        return 'Best Stories';
    }
  }
}


@riverpod
NewsService newsService(NewsServiceRef ref) {
  return NewsService();
}


@riverpod
Future<List<NewsFormat>> stories(StoriesRef ref, StoryType type) async {
  final service = ref.read(newsServiceProvider);
 
  final ids = await service.getStoryIds(type.apiPath);
  
  final limitedIds = ids.take(30).toList();

  return await service.getStories(limitedIds);
}

@riverpod
Future<NewsFormat> storyDetail(StoryDetailRef ref, int id) async {
  final service = ref.read(newsServiceProvider);
  return await service.getStory(id);
}

@riverpod
Future<List<NewsFormat>> comments(CommentsRef ref, int storyId) async {
  final service = ref.read(newsServiceProvider);
  
  final story = await service.getStory(storyId);
  
  if (story.kids != null && story.kids!.isNotEmpty) {
    return await service.getComments(story.kids!);
  }
  
  return [];
}

// favorites providers removed