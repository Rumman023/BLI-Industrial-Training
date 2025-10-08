import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import '../models/news_format.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Store names
  static const String STORIES_STORE = 'stories';
  static const String COMMENTS_STORE = 'comments';
  static const String STORY_IDS_STORE = 'story_ids';

  // Store instances
  final _storiesStore = intMapStoreFactory.store(STORIES_STORE);
  final _commentsStore = intMapStoreFactory.store(COMMENTS_STORE);
  final _storyIdsStore = stringMapStoreFactory.store(STORY_IDS_STORE);

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final dbPath = join(appDir.path, 'news_app.db');
    print('[DATABASE] Initializing database at: $dbPath');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  // Save story IDs for a specific type
  Future<void> saveStoryIds(String type, List<int> ids) async {
    final db = await database;
    await _storyIdsStore.record(type).put(db, {
      'ids': ids,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    print('[DATABASE] Saved ${ids.length} story IDs for type: $type');
  }

  // Get story IDs for a specific type
  Future<List<int>?> getStoryIds(String type) async {
    final db = await database;
    final record = await _storyIdsStore.record(type).get(db);
    if (record == null) return null;

    // Check if data is fresh (less than 5 minutes old)
    final timestamp = record['timestamp'] as int;
    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > 300000) return null; // 5 minutes in milliseconds

    return List<int>.from(record['ids'] as List);
  }

  // Save a single story
  Future<void> saveStory(NewsFormat story) async {
    if (story.id == null) return;
    final db = await database;
    await _storiesStore.record(story.id!).put(db, story.toJson());
    print('[DATABASE] Saved story: ${story.id}');
  }

  // Save multiple stories
  Future<void> saveStories(List<NewsFormat> stories) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var story in stories) {
        if (story.id != null) {
          await _storiesStore.record(story.id!).put(txn, story.toJson());
        }
      }
    });
    print('[DATABASE] Saved ${stories.length} stories');
  }

  // Get a single story by ID
  Future<NewsFormat?> getStory(int id) async {
    final db = await database;
    final record = await _storiesStore.record(id).get(db);
    if (record == null) return null;
    return NewsFormat.fromJson(record);
  }

  // Get multiple stories by IDs
  Future<List<NewsFormat>> getStories(List<int> ids) async {
    final db = await database;
    final stories = <NewsFormat>[];
    
    for (var id in ids) {
      final record = await _storiesStore.record(id).get(db);
      if (record != null) {
        stories.add(NewsFormat.fromJson(record));
      }
    }
    
    return stories;
  }

  // Save a comment
  Future<void> saveComment(NewsFormat comment) async {
    if (comment.id == null) return;
    final db = await database;
    await _commentsStore.record(comment.id!).put(db, comment.toJson());
  }

  // Save multiple comments
  Future<void> saveComments(List<NewsFormat> comments) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var comment in comments) {
        if (comment.id != null) {
          await _commentsStore.record(comment.id!).put(txn, comment.toJson());
        }
      }
    });
    print('[DATABASE] Saved ${comments.length} comments');
  }

  // Get a single comment by ID
  Future<NewsFormat?> getComment(int id) async {
    final db = await database;
    final record = await _commentsStore.record(id).get(db);
    if (record == null) return null;
    return NewsFormat.fromJson(record);
  }

  // Get multiple comments by IDs
  Future<List<NewsFormat>> getComments(List<int> ids) async {
    final db = await database;
    final comments = <NewsFormat>[];
    
    for (var id in ids) {
      final record = await _commentsStore.record(id).get(db);
      if (record != null) {
        comments.add(NewsFormat.fromJson(record));
      }
    }
    
    return comments;
  }

  // Clear all data (useful for testing)
  Future<void> clearAll() async {
    final db = await database;
    await _storiesStore.delete(db);
    await _commentsStore.delete(db);
    await _storyIdsStore.delete(db);
    print('[DATABASE] Cleared all data');
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}