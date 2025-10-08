import 'package:flutter/material.dart';
import '../models/news_format.dart';
import '../utils/html_parser.dart';

class CommentWidget extends StatelessWidget {
  final NewsFormat comment;
  final int depth;

  const CommentWidget({
    super.key,
    required this.comment,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (comment.text == null || comment.by == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(
        left: depth * 16.0,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.blue[300]!,
            width: 2,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(left: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    comment.by!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (comment.time != null)
                    Text(
                      _formatTime(comment.time!),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Comment Text
              Text(
                HtmlParser.parse(comment.text!),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}