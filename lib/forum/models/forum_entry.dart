// To parse this JSON data, do
//
//     final forumEntry = forumEntryFromJson(jsonString);

import 'dart:convert';

List<ForumEntry> forumEntryFromJson(String str) => List<ForumEntry>.from(json.decode(str).map((x) => ForumEntry.fromJson(x)));

String forumEntryToJson(List<ForumEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumEntry {
    String id;
    String title;
    String author;
    String content;
    DateTime createdAt;
    DateTime updatedAt;
    int views;
    int commentCount;
    int authorId;

    ForumEntry({
        required this.id,
        required this.title,
        required this.author,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.views,
        required this.commentCount,
        required this.authorId,
    });

    factory ForumEntry.fromJson(Map<String, dynamic> json) => ForumEntry(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        views: json["views"],
        commentCount: json["comment_count"],
        authorId: json["author_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "views": views,
        "comment_count": commentCount,
        "author_id": authorId,
    };
}
