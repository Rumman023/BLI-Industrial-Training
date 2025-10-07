import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/note_list/note_list_page.dart';
import '../features/note_detail/note_detail_page.dart';
import '../features/settings/settings_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const NoteListPage(),
      ),
      GoRoute(
        path: '/note/:id',
        name: 'note-detail',
        builder: (context, state) {
          final noteId = state.pathParameters['id'];
          return NoteDetailPage(noteId: noteId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}