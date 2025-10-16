// lib/providers/chat_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;
import '../models/chat_models.dart';
import '../services/database_service.dart';
import '../services/ollama_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final service = DatabaseService();
  service.init();
  return service;
});

final ollamaServiceProvider = Provider<OllamaService>((ref) {
  // On Android emulator, the host machine is reachable at 10.0.2.2.
  if (Platform.isAndroid) {
    return OllamaService(baseUrl: 'http://10.0.2.2:11434', model: 'qwen2.5:0.5b');
  }
  // Default: localhost for desktop dev.
  return OllamaService(baseUrl: 'http://localhost:11434', model: 'qwen2.5:0.5b');
});

final chatSessionsProvider = StateNotifierProvider<ChatSessionsNotifier, List<ChatSession>>((ref) {
  return ChatSessionsNotifier(ref.read(databaseServiceProvider));
});

final currentSessionProvider = StateProvider<ChatSession?>((ref) => null);

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessage>, String>(
  (ref, sessionId) {
    return ChatMessagesNotifier(ref.read(databaseServiceProvider), sessionId);
  },
);

class ChatSessionsNotifier extends StateNotifier<List<ChatSession>> {
  final DatabaseService _databaseService;

  ChatSessionsNotifier(this._databaseService) : super([]) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    final sessions = await _databaseService.getSessions();
    state = sessions;
  }

  Future<ChatSession> createSession(String title) async {
    final session = ChatSession(title: title);
    await _databaseService.saveSession(session);
    state = [session, ...state];
    return session;
  }

  Future<void> deleteSession(String sessionId) async {
    await _databaseService.deleteSession(sessionId);
    state = state.where((session) => session.id != sessionId).toList();
  }

  Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    final sessionIndex = state.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      final updatedSession = state[sessionIndex].copyWith(title: newTitle);
      await _databaseService.saveSession(updatedSession);
      state = [
        ...state.sublist(0, sessionIndex),
        updatedSession,
        ...state.sublist(sessionIndex + 1),
      ];
    }
  }
}

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final DatabaseService _databaseService;
  final String sessionId;

  ChatMessagesNotifier(this._databaseService, this.sessionId) : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    final messages = await _databaseService.getMessages(sessionId);
    state = messages;
  }

  Future<void> addMessage(ChatMessage message) async {
    await _databaseService.saveMessage(sessionId, message);
    state = [...state, message];
  }

  /// Update an existing message's content (and persist it).
  Future<void> updateMessageContent(String messageId, String newContent) async {
    final idx = state.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;
    final updated = ChatMessage(
      id: state[idx].id,
      content: newContent,
      isUser: state[idx].isUser,
      timestamp: state[idx].timestamp,
    );
    await _databaseService.saveMessage(sessionId, updated);
    final newState = [...state];
    newState[idx] = updated;
    state = newState;
  }

  Future<void> clearMessages() async {
    await _databaseService.deleteMessagesForSession(sessionId);
    state = [];
  }
}