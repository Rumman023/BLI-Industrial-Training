import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../models/note.dart';
import '../../core/provider.dart';

part 'note_detail_ctrl.g.dart';

@riverpod
class NoteDetailController extends _$NoteDetailController {
  @override
  Future<Note?> build(String? noteId) async {
    if (noteId == null || noteId == 'new') {
      // Create a new note
      return Note(
        id: const Uuid().v4(),
        title: '',
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Load existing note
    final db = ref.read(databaseServiceProvider);
    return await db.getNote(noteId);
  }

  // Save the note
  Future<void> saveNote(String title, String content) async {
    final currentNote = state.value;
    if (currentNote == null) return;

    final updatedNote = currentNote.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    final db = ref.read(databaseServiceProvider);
    await db.saveNote(updatedNote);

    state = AsyncValue.data(updatedNote);
  }

  // Update title only
  void updateTitle(String title) {
    final currentNote = state.value;
    if (currentNote == null) return;

    state = AsyncValue.data(
      currentNote.copyWith(title: title),
    );
  }

  // Update content only
  void updateContent(String content) {
    final currentNote = state.value;
    if (currentNote == null) return;

    state = AsyncValue.data(
      currentNote.copyWith(content: content),
    );
  }
}