import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'note_detail_ctrl.dart';
import '../note_list/note_list_ctrl.dart';

class NoteDetailPage extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteDetailPage({super.key, this.noteId});

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteDetailControllerProvider(widget.noteId));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.noteId == 'new' ? 'New Note' : 'Edit Note'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _saveNote(),
            ),
          ],
        ),
        body: noteAsync.when(
          data: (note) {
            if (note == null) {
              return const Center(
                child: Text('Note not found'),
              );
            }

            // Initialize controllers with note data
            if (_titleController.text.isEmpty && note.title.isNotEmpty) {
              _titleController.text = note.title;
            }
            if (_contentController.text.isEmpty && note.content.isNotEmpty) {
              _contentController.text = note.content;
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Note Title',
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                    onChanged: (value) {
                      _hasChanges = true;
                      ref
                          .read(noteDetailControllerProvider(widget.noteId).notifier)
                          .updateTitle(value);
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Start typing your note...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: (value) {
                        _hasChanges = true;
                        ref
                            .read(noteDetailControllerProvider(widget.noteId).notifier)
                            .updateContent(value);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final controller =
        ref.read(noteDetailControllerProvider(widget.noteId).notifier);
    await controller.saveNote(
      _titleController.text.trim(),
      _contentController.text.trim(),
    );

    ref.invalidate(noteListControllerProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved'),
          duration: Duration(seconds: 1),
        ),
      );
      context.pop();
    }
  }

  Future<void> _handleBack() async {
    if (_hasChanges) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Save changes?'),
          content: const Text('Do you want to save your changes before leaving?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (shouldSave == true) {
        await _saveNote();
      } else if (shouldSave == false) {
        if (mounted) context.pop();
      }
    } else {
      if (mounted) context.pop();
    }
  }
}