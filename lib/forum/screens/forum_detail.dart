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
  String? _errorMessage;
  ForumEntry? currentForum;
  late Future<List<CommentEntry>> _commentsFuture;
  bool _isLoading = true;

  final TextEditingController _commentController = TextEditingController();
  
  final ScrollController _scrollController = ScrollController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAllData();
  }

  void _showDeleteCommentConfirmation(CookieRequest request, String commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Comment", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this comment?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              navigator.pop(context);
              final response = await request.postJson(
                "http://localhost:8000/forum/delete-comment-flutter/",
                jsonEncode({"comment_id": commentId}),
              );

              if (!mounted) return;

              if (response['status'] == 'success') {
                _loadAllData();
                messenger.showSnackBar(
                  const SnackBar(content: Text("Comment successfully deleted!")),
                );
              } else {
                messenger.showSnackBar(
                  SnackBar(content: Text(response['message'] ?? "Unauthorized or failed to delete.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600], foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(), 
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7, 
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(Icons.cloud_off_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              "Failed to load forum detail",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? "Check your internet connection.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAllData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
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
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "fail";
        });
      }
    }
  }

  Future<List<CommentEntry>> fetchComments(CookieRequest request, String id) async {
    try {
      final response = await request.get("http://localhost:8000/forum/json-comment/$id");
      if (response is! List) {
        throw Exception("Invalid data format from server");
      }

      return response
          .where((d) => d != null)
          .map((d) => CommentEntry.fromJson(d))
          .toList();
          
    } catch (e) {
      debugPrint("Error Fetch Comments: $e");
      throw Exception("Failed to connect.");
    }
  }

  Future<void> _submitComment(CookieRequest request) async {
    if (_commentController.text.trim().isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);

    final response = await request.postJson(
      "http://localhost:8000/forum/create-comment-flutter/",
      jsonEncode({
        "forum_id": widget.forumId,
        "content": _commentController.text,
      }),
    );

    if (!mounted) return;

    if (response['status'] == 'success') {
      _commentController.clear();
      _commentFocusNode.unfocus();
      _loadAllData();
      messenger.showSnackBar(const SnackBar(content: Text("Comment added!")));
    }
  }

  Future<void> _deleteForum(CookieRequest request) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final response = await request.postJson(
      "http://localhost:8000/forum/delete-forum-flutter/",
      jsonEncode({"forum_id": widget.forumId}),
    );

    if (!mounted) {
      return;
    }

    if (response['status'] == 'success') {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Forum successfully deleted!"),
        ),
      );
      navigator.pop();
      navigator.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Failed to delete forum. Please try again."),
        ),
      );
    }
  }

  void _showEditCommentModal(CookieRequest request, CommentEntry comment) {
    final TextEditingController editC = TextEditingController(text: comment.content);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, 
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit Comment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: editC,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Edit your comment...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final response = await request.postJson(
                    "http://localhost:8000/forum/edit-comment-flutter/",
                    jsonEncode({"comment_id": comment.id, "content": editC.text}),
                  );

                  if (!mounted) return;

                  if (response['status'] == 'success') {
                    Navigator.pop(context);
                    _loadAllData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Comment successfully edited!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'] ?? "Failed to edit comment.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save Changes"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete Forum", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => _deleteForum(request),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600], foregroundColor: Colors.white),
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
            _commentFocusNode.requestFocus();
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
          icon: const Icon(Icons.chat_bubble, size: 18),
          label: const Text("Add Comment"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
        ),
        const Spacer(),
        if (isOwner)
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ForumEditFormPage(forum: currentForum!)));
              if (result == true) { setState(() => _isLoading = true); _loadAllData(); }
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
          ),
        if (isOwner || isStaff)
          IconButton(onPressed: () => _showDeleteConfirmation(request), icon: const Icon(Icons.delete_outline, color: Colors.red)),
      ],
    );
  }

  Widget _buildMainContent(CookieRequest request) {
    final createdAt = DateFormat('MMM dd, yyyy • HH:mm').format(currentForum!.createdAt.toLocal());
    final updatedAt = DateFormat('MMM dd, yyyy • HH:mm').format(currentForum!.updatedAt.toLocal());

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FORUM DETAIL CARD ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentForum!.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    Wrap(spacing: 16, children: [
                      _buildMetaItem(Icons.person_outline, currentForum!.author),
                      _buildMetaItem(Icons.calendar_today_outlined, "Posted: $createdAt"),
                      _buildMetaItem(Icons.update_outlined, "Updated: $updatedAt"),
                      _buildMetaItem(Icons.visibility_outlined, "${currentForum!.views} views"),
                    ]),
                    const SizedBox(height: 32),
                    Text(currentForum!.content, style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF374151))),
                    const SizedBox(height: 24),
                    _buildForumActions(request),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- COMMENTS LIST ---
              FutureBuilder<List<CommentEntry>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: Colors.black)),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.comments_disabled_outlined, size: 48, color: Color(0xFF9CA3AF)),
                          const SizedBox(height: 16),
                          const Text(
                            "Failed to load comment",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Something went wrong while retrieving the data.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 140,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _commentsFuture = fetchComments(request, widget.forumId);
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text("Try Again"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black, width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final List<CommentEntry> comments = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Comment (${comments.length})", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (comments.isEmpty) const SizedBox(height: 50) 
                      else ListView.builder(
                        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) => CommentCard(
                          item: comments[index],
                          currentUsername: request.jsonData['username'] ?? "",
                          forumAuthor: currentForum!.author,
                          isStaff: request.jsonData['is_staff'] ?? false,
                          onEdit: () => _showEditCommentModal(request, comments[index]),
                          onDelete: () => _showDeleteCommentConfirmation(request, comments[index].id),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // --- ADD COMMENT FORM ---
              const Text(
                "Add Comment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your comment...",
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  fillColor: Colors.white,
                  filled: true,
                  hoverColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 12),

              // --- SEPARATE BUTTON (Rapat Kanan) ---
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _submitComment(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Post Comment",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator(color: Colors.black));
    } else if (_errorMessage != null || currentForum == null) {
      bodyContent = _buildErrorState();
    } else {
      bodyContent = _buildMainContent(request); 
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Forum Detail', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),  
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: bodyContent,
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
    ]);
  }
}