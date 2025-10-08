//lib/services/news_service.dart
import 'package:dio/dio.dart';
import '../models/news_format.dart';
import '../database/database_helper.dart';

class NewsService {
  final Dio _dio;
  final DatabaseHelper _dbHelper;

  NewsService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hacker-news.firebaseio.com/v0/',
            connectTimeout: const Duration(seconds: 300),
            receiveTimeout: const Duration(seconds: 300),
          ),
        ),
        _dbHelper = DatabaseHelper();

  
  Future<List<int>> getStoryIds(String type) async {
    try {
      // try getting from local database first
      final cachedIds = await _dbHelper.getStoryIds(type);
      if (cachedIds != null && cachedIds.isNotEmpty) {
        print('[CACHE] Using cached $type story IDs');
        return cachedIds;
      }

      // fetch from API
      print('[API] Fetching $type stories...');
      final response = await _dio.get('$type.json');
      final ids = List<int>.from(response.data as List);
      
      // save to database
      await _dbHelper.saveStoryIds(type, ids);
      
      print('[SUCCESS] Got ${ids.length} $type story IDs');
      return ids;
    } on DioException catch (e) {
      print('[FAILED] Error fetching $type stories: ${e.message}');
      
      // try returning cached data even if expired
      final cachedIds = await _dbHelper.getStoryIds(type);
      if (cachedIds != null && cachedIds.isNotEmpty) {
        print('[CACHE] Returning expired cache as fallback');
        return cachedIds;
      }
      
      throw Exception('Failed to load $type stories: ${e.message}');
    }
  }


  Future<NewsFormat> getStory(int id) async {
    try {
      // Try getting from local database first
      final cachedStory = await _dbHelper.getStory(id);
      if (cachedStory != null) {
        print('[CACHE] Using cached story: $id');
        return cachedStory;
      }

      // fetch from API
      print('[API] Fetching story: $id');
      final response = await _dio.get('item/$id.json');
      final story = NewsFormat.fromJson(response.data as Map<String, dynamic>);
      
      // save to database
      await _dbHelper.saveStory(story);
      
      return story;
    } on DioException catch (e) {
      print('[FAILED] Error fetching story $id: ${e.message}');
      
      // try returning cached data as fallback
      final cachedStory = await _dbHelper.getStory(id);
      if (cachedStory != null) {
        print('[CACHE] Returning cached story as fallback');
        return cachedStory;
      }
      
      throw Exception('Failed to load story $id: ${e.message}');
    }
  }


  Future<List<NewsFormat>> getStories(List<int> ids) async {
    try {
      print('[WAITING] Fetching ${ids.length} stories...');
      
      // try getting from cache first
      final cachedStories = await _dbHelper.getStories(ids);
      
      if (cachedStories.length == ids.length) {
        print('[CACHE] All stories found in cache');
        return cachedStories;
      }

      // fetch missing stories from API
      final stories = await Future.wait(
        ids.take(30).map((id) => getStory(id)),
      );
      
      // save all stories to database
      await _dbHelper.saveStories(stories);
      
      print('[SUCCESS] Successfully loaded ${stories.length} stories');
      return stories;
    } catch (e) {
      print('[FAILED] Error fetching stories: $e');
      
      // return everything from cache
      final cachedStories = await _dbHelper.getStories(ids);
      if (cachedStories.isNotEmpty) {
        print('[CACHE] Returning ${cachedStories.length} cached stories');
        return cachedStories;
      }
      
      throw Exception('Failed to load stories: $e');
    }
  }

  Future<List<NewsFormat>> getComments(List<int> commentIds) async {
    try {
      if (commentIds.isEmpty) return [];

      print('[WAITING] Fetching ${commentIds.length} comments...');
      
      
      final cachedComments = await _dbHelper.getComments(commentIds);
      
      if (cachedComments.length == commentIds.length) {
        print('[CACHE] All comments found in cache');
        return cachedComments;
      }

      final comments = <NewsFormat>[];
      for (var id in commentIds) {
        try {
          final comment = await getComment(id);
          comments.add(comment);
        } catch (e) {
          print('[WARNING] Failed to fetch comment $id: $e');
        
        }
      }
     
      if (comments.isNotEmpty) {
        await _dbHelper.saveComments(comments);
      }
      
      print('[SUCCESS] Successfully loaded ${comments.length} comments');
      return comments;
    } catch (e) {
      print('[FAILED] Error fetching comments: $e');
      
      final cachedComments = await _dbHelper.getComments(commentIds);
      if (cachedComments.isNotEmpty) {
        print('[CACHE] Returning ${cachedComments.length} cached comments');
        return cachedComments;
      }
      
      return [];
    }
  }

  Future<NewsFormat> getComment(int id) async {
    try {
      final cachedComment = await _dbHelper.getComment(id);
      if (cachedComment != null) {
        return cachedComment;
      }

      final response = await _dio.get('item/$id.json');
      final comment = NewsFormat.fromJson(response.data as Map<String, dynamic>);
      
      await _dbHelper.saveComment(comment);
      
      return comment;
    } catch (e) {
      throw Exception('Failed to load comment $id: $e');
    }
  }
}