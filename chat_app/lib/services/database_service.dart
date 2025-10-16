// lib/services/database_service.dart
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/chat_models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  final _sessionsStore = stringMapStoreFactory.store('sessions');
  final _messagesStore = stringMapStoreFactory.store('messages');
  Future<void>? _initFuture;

  Future<void> init() async {
    if (_initFuture != null) return _initFuture!;
    _initFuture = _doInit();
    return _initFuture!;
  }

  Future<void> _doInit() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'chat_app.db');
      _database = await databaseFactoryIo.openDatabase(dbPath);
      print('Database initialized at: $dbPath');
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _ensureInit() async {
    if (_initFuture == null) {
      _initFuture = _doInit();
    }
    await _initFuture;
  }

  // Session operations
  Future<void> saveSession(ChatSession session) async {
    await _ensureInit();
    await _sessionsStore.record(session.id).put(_database!, session.toMap());
  }

  Future<List<ChatSession>> getSessions() async {
    await _ensureInit();
    final records = await _sessionsStore.find(
      _database!,
      finder: Finder(sortOrders: [SortOrder('createdAt', false)]),
    );
    return records.map((record) => ChatSession.fromMap(record.value)).toList();
  }

  Future<void> deleteSession(String sessionId) async {
    await _ensureInit();
    await _sessionsStore.record(sessionId).delete(_database!);
    final finder = Finder(filter: Filter.equals('sessionId', sessionId));
    await _messagesStore.delete(_database!, finder: finder);
  }

  // Message operations
  Future<void> saveMessage(String sessionId, ChatMessage message) async {
    await _ensureInit();
    final messageMap = message.toMap();
    messageMap['sessionId'] = sessionId;
    await _messagesStore.record(message.id).put(_database!, messageMap);
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    await _ensureInit();
    final finder = Finder(
      filter: Filter.equals('sessionId', sessionId),
      sortOrders: [SortOrder('timestamp')],
    );
    final records = await _messagesStore.find(_database!, finder: finder);
    return records.map((record) => ChatMessage.fromMap(record.value)).toList();
  }

  Future<void> deleteMessagesForSession(String sessionId) async {
    await _ensureInit();
    final finder = Finder(filter: Filter.equals('sessionId', sessionId));
    await _messagesStore.delete(_database!, finder: finder);
  }
}