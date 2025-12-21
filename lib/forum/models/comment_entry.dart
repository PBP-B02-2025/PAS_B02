// To parse this JSON data, do
//
//     final commentEntry = commentEntryFromJson(jsonString);

import 'dart:convert';

List<CommentEntry> commentEntryFromJson(String str) => List<CommentEntry>.from(json.decode(str).map((x) => CommentEntry.fromJson(x)));

String commentEntryToJson(List<CommentEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentEntry {
    String id;
    String author;
    String content;
    DateTime createdAt;
    DateTime updatedAt;
    int authorId;

    CommentEntry({
        required this.id,
        required this.author,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.authorId,
    });

    factory CommentEntry.fromJson(Map<String, dynamic> json) => CommentEntry(
        id: json["id"],
        author: json["author"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        authorId: json["author_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "author_id": authorId,
    };
}
