import 'dart:convert';

import 'package:ballistic/forum/models/forum_entry.dart';
import 'package:ballistic/forum/screens/forum_edit_form.dart';
import 'package:ballistic/forum/widgets/comment_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:ballistic/forum/models/comment_entry.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumDetailPage extends StatefulWidget {
  final String forumId;
  const ForumDetailPage({super.key, required this.forumId});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  ForumEntry? currentForum;
  late Future<List<CommentEntry>> _commentsFuture;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final request = context.read<CookieRequest>();
    try {
      final responseForum = await request.get("http://localhost:8000/forum/json-forum/${widget.forumId}");
      
      _commentsFuture = fetchComments(request, widget.forumId);
      if (mounted) {
        setState(() {
          currentForum = ForumEntry.fromJson(responseForum); 
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  Future<List<CommentEntry>> fetchComments(CookieRequest request, String id) async {
    final response = await request.get("http://localhost:8000/forum/json-comment/$id");
    List<CommentEntry> comments = [];
    for (var d in response) {
      if (d != null) {
        comments.add(CommentEntry.fromJson(d));
      }
    }
    return comments;
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
      ],
    );
  }

  Future<void> _deleteForum(CookieRequest request) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final response = await request.postJson(
      "http://localhost:8000/forum/delete-forum-flutter/",
      jsonEncode({
        "forum_id": widget.forumId,
      }),
    );

    if (response['status'] == 'success') {
      messenger.showSnackBar(
        const SnackBar(content: Text("Forum successfully deleted!")),
      );
      navigator.pop();
      navigator.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to delete forum.")),
      );
    }
  }

  void _showDeleteConfirmation(CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Forum", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this forum? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => _deleteForum(request),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildForumActions(CookieRequest request) {
    final bool isOwner = request.jsonData['username'] == currentForum!.author;
    final bool isStaff = request.jsonData['is_staff'] ?? false;

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Logic scroll ke field input atau modal
          },
          icon: const Icon(Icons.chat_bubble, size: 18),
          label: const Text("Add Comment"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const Spacer(),
        if (isOwner)
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForumEditFormPage(forum: currentForum!)),
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _loadAllData();
              }
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
          ),
        if (isOwner || isStaff)
          IconButton(
            onPressed: () {
              _showDeleteConfirmation(request);
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (_isLoading || currentForum == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final createdAt = DateFormat('MMM dd, yyyy • HH:mm').format(currentForum!.createdAt.toLocal());
    final updatedAt = DateFormat('MMM dd, yyyy • HH:mm').format(currentForum!.updatedAt.toLocal());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Forum Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- FORUM DETAIL CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentForum!.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _buildMetaItem(Icons.person_outline, currentForum!.author),
                            _buildMetaItem(Icons.calendar_today_outlined, "Posted: $createdAt"),
                            _buildMetaItem(Icons.update_outlined, "Updated: $updatedAt"),
                            _buildMetaItem(Icons.visibility_outlined, "${currentForum!.views} views"),
                          ],
                        ),
                        const Divider(height: 32, thickness: 1, color: Color(0xFFF3F4F6)),
                        Text(
                          currentForum!.content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildForumActions(request),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- COMMENTS SECTION ---
                  FutureBuilder<List<CommentEntry>>(
                    future: _commentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      final List<CommentEntry> comments = snapshot.data ?? [];
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Comment (${comments.length})", 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          if (comments.isEmpty)
                            const SizedBox(height: 100)
                          else 
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return CommentCard(
                                  item: comment,
                                  currentUsername: request.jsonData['username'] ?? "",
                                  forumAuthor: currentForum!.author,
                                  isStaff: request.jsonData['is_staff'] ?? false,
                                  onEdit: () {
                                    // Buka modal edit komentar
                                  },
                                  onDelete: () {
                                    // Dialog hapus komentar
                                  },
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}