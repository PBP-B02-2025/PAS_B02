import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumFormPage extends StatefulWidget {
  const ForumFormPage({super.key});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();

  @override
  void dispose() {
    titleC.dispose();
    contentC.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFFC9A25B),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create New Forum",
          style: TextStyle(
            color: Colors.white,
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
                  "Start a new forum thread and share your thoughts",
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
                            "https://jovian-felix-ballistic.pbp.cs.ui.ac.id/forum/create-forum-flutter/",
                            jsonEncode({
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
                                content: Text("Forum successfully created!"),
                              ),
                            );
                            navigator.pop(true);
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ?? "Failed to create forum.",
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
                          "Publish Forum",
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
