//lib/pages/sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_providers.dart';
import '../models/chat_models.dart';

class Sidebar extends ConsumerStatefulWidget {
  final Function(ChatSession) onSessionSelected;
  final VoidCallback onCreateNewChat;
  final VoidCallback onClose;

  const Sidebar({
    super.key,
    required this.onSessionSelected,
    required this.onCreateNewChat,
    required this.onClose,
  });

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  List<bool> _visible = [];

  void _ensureVisibilityFlags(int count) {
    if (_visible.length != count) {
      _visible = List<bool>.filled(count, false);
      for (var i = 0; i < count; i++) {
        Future.delayed(Duration(milliseconds: 80 * i + 80), () {
          if (!mounted) return;
          setState(() => _visible[i] = true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(chatSessionsProvider);
    final currentSession = ref.watch(currentSessionProvider);

    _ensureVisibilityFlags(sessions.length);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Chat History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: widget.onCreateNewChat,
                  tooltip: 'New Chat',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                ),
              ],
            ),
          ),

          // Sessions list
          Expanded(
            child: sessions.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: sessions.length,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return _buildAnimatedSessionItem(
                          context, ref, session, currentSession, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSessionItem(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
    ChatSession? currentSession,
    int index,
  ) {
    final visible = index < _visible.length ? _visible[index] : true;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      opacity: visible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 350),
        offset: visible ? Offset.zero : const Offset(-0.08, 0),
        child: _buildSessionItem(context, ref, session, currentSession),
      ),
    );
  }

  Widget _buildSessionItem(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
    ChatSession? currentSession,
  ) {
    final messages = ref.watch(chatMessagesProvider(session.id));

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(
        Icons.chat_bubble_outline,
        size: 20,
        color: currentSession?.id == session.id 
            ? Theme.of(context).colorScheme.primary 
            : null,
      ),
      title: Text(
        session.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          fontWeight: currentSession?.id == session.id 
              ? FontWeight.w600 
              : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        '${messages.length} messages',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: () => _deleteSession(context, ref, session),
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
      ),
      selected: currentSession?.id == session.id,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () => widget.onSessionSelected(session),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No chat history',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new conversation!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteSession(
      BuildContext context, WidgetRef ref, ChatSession session) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ref.read(chatSessionsProvider.notifier).deleteSession(session.id);
      final currentSession = ref.read(currentSessionProvider);
      if (currentSession?.id == session.id) {
        final sessions = ref.read(chatSessionsProvider);
        if (sessions.isNotEmpty) {
          ref.read(currentSessionProvider.notifier).state = sessions.first;
        } else {
          ref.read(currentSessionProvider.notifier).state = null;
        }
      }
    }
  }
}