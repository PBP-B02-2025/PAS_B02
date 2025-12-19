import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forum_entry.dart';

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int value;

  const _StatItem({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}


class ForumCard extends StatelessWidget {
  final ForumEntry item;
  final VoidCallback onTap;

  const ForumCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final updatedAt =
        DateFormat('MMM dd, yyyy • HH:mm').format(item.updatedAt);

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 8),

              /// Content
              Text(
                item.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                ),
              ),

              const Spacer(),

              const Divider(height: 24),

              /// Author & last activity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'By ',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                      children: [
                        TextSpan(
                          text: item.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last activity: $updatedAt',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _StatItem(
                    icon: Icons.comment_outlined,
                    value: item.commentCount,
                  ),
                  const SizedBox(width: 12),
                  _StatItem(
                    icon: Icons.visibility_outlined,
                    value: item.views,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
