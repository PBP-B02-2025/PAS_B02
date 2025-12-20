import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/comment_entry.dart';

class CommentCard extends StatelessWidget {
  final CommentEntry item;
  final String currentUsername;
  final String forumAuthor;
  final bool isStaff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CommentCard({
    super.key,
    required this.item,
    required this.currentUsername,
    required this.forumAuthor,
    required this.isStaff,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCommentOwner = currentUsername == item.author;
    final bool isForumOwner = currentUsername == forumAuthor;
    final bool canDelete = isCommentOwner || isForumOwner || isStaff;
    final bool canEdit = isCommentOwner;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          "Posted: ${DateFormat('MMM dd, yyyy • HH:mm').format(item.createdAt.toLocal())}",
                          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                        ),
                        if (item.updatedAt.isAfter(item.createdAt))
                          Text(
                            "• Edited: ${DateFormat('MMM dd, yyyy • HH:mm').format(item.updatedAt.toLocal())}",
                            style: const TextStyle(
                              fontSize: 11, 
                              color: Color(0xFF9CA3AF), 
                              fontStyle: FontStyle.italic
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Row(
                children: [
                  if (canEdit)
                    _CircleActionBtn(
                      icon: Icons.edit_outlined,
                      color: Colors.blue,
                      onTap: onEdit,
                    ),
                  if (canEdit && canDelete) 
                    const SizedBox(width: 8),
                  if (canDelete)
                    _CircleActionBtn(
                      icon: Icons.delete_outline,
                      color: Colors.red,
                      onTap: onDelete,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}