import 'dart:convert';
import 'package:ballistic/forum/models/forum_entry.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumEditFormPage extends StatefulWidget {
  final ForumEntry forum;
  const ForumEditFormPage({super.key, required this.forum});

  @override
  State<ForumEditFormPage> createState() => _ForumEditFormPageState();
}

class _ForumEditFormPageState extends State<ForumEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late ForumEntry currentForum;

  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();

  @override
  void dispose() {
    titleC.dispose();
    contentC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentForum = widget.forum;
    titleC.text = currentForum.title;
    contentC.text = currentForum.content;
  }

  InputDecoration _formStyle(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14, color: Colors.black87),
    contentPadding: const EdgeInsets.all(12),

    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Color(0xFFBCBCBC)),
      borderRadius: BorderRadius.circular(6),
    ),

    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Colors.black87),
      borderRadius: BorderRadius.circular(6),
    ),

    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Color(0xFFBCBCBC)),
      borderRadius: BorderRadius.circular(6),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Colors.black87),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Current Forum",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Update your forum post below",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                /// TITLE
                TextFormField(
                  controller: titleC,
                  decoration: _formStyle("Title"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Title is required!";
                    }
                    if (v.trim().length > 255) {
                      return "Title max 255 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                /// CONTENT
                TextFormField(
                  controller: contentC,
                  maxLines: 10,
                  decoration: _formStyle("Content"),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Content is required!" : null,
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    /// Cancel
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Publish Forum
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);

                          final response = await request.postJson(
                            "http://localhost:8000/forum/edit-forum-flutter/",
                            jsonEncode({
                              "forum_id": currentForum.id,
                              "title": titleC.text,
                              "content": contentC.text,
                            }),
                          );

                          if (!mounted) {
                            return;
                          }

                          if (response['status'] == 'success') {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text("Forum successfully edited!"),
                              ),
                            );
                            navigator.pop(true);
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ?? "Failed to edit forum.",
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
