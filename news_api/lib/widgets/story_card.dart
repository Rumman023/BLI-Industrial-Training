import 'package:flutter/material.dart';
import '../models/news_format.dart';

class StoryCard extends StatelessWidget {
  final NewsFormat story;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          story.title ?? 'No title',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (story.by != null) ...[
              Text('By: ${story.by}', 
               style: TextStyle(fontSize: 14, color: Colors.blue[200]),),
              const SizedBox(height: 4),
              
            ],
            if (story.time != null) ...[
              Text(
                'Posted: ${_formatTime(story.time!)}',
                style: TextStyle(fontSize: 12, color: Colors.red[200]),
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}