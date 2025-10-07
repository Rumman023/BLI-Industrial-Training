import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/note.dart';
import '../../core/provider.dart';

part 'note_list_ctrl.g.dart';

@riverpod
class NoteListController extends _$NoteListController {
  @override
  Future<List<Note>> build() async {
    return await _loadNotes();
  }

  Future<List<Note>> _loadNotes() async {
    final db = ref.read(databaseServiceProvider);
    return await db.getAllNotes();
  }

  // Refresh the note list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadNotes();
    });
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    final db = ref.read(databaseServiceProvider);
    await db.deleteNote(noteId);
    await refresh();
  }
}