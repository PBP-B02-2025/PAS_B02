import 'package:ballistic/forum/screens/forum_form.dart';
import 'package:ballistic/forum/widgets/forum_entry_card.dart';
import 'package:ballistic/forum/widgets/forum_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:ballistic/forum/models/forum_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPage();
}

class _ForumListPage extends State<ForumListPage> {
  String filter = "all";
  String sort = "newest";

  void _onFilterChanged(String value) {
    setState(() {
      filter = value;
    });
  }

  void _onSortChanged(String value) {
    setState(() {
      sort = value;
    });
  }

  Future<List<ForumEntry>> fetchForum(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/forum/json-forum/');

    var data = response;

    List<ForumEntry> listForum = [];
    for (var d in data) {
      if (d != null) {
        listForum.add(ForumEntry.fromJson(d));
      }
    }

    return listForum;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum – Ballistic',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          ForumToolbar(
            activeFilter: filter,
            sortValue: sort,
            onFilterChanged: _onFilterChanged,
            onSortChanged: _onSortChanged,
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchForum(request),
              builder: (context,snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<ForumEntry> forumList = snapshot.data!;
                  List<ForumEntry> displayedForums = [];
                  if (filter == "all") {
                    displayedForums = forumList;
                  } else {
                    displayedForums = forumList.where((p) => p.author == request.jsonData['username']).toList();
                  }
                  displayedForums.sort((a, b) {
                    switch (sort) {
                      case 'oldest':
                        return a.createdAt.compareTo(b.createdAt);
                      case 'popular':
                        return b.views.compareTo(a.views);
                      default:
                        return b.createdAt.compareTo(a.createdAt);
                    }
                  });

                  if (displayedForums.isEmpty) {

                  } else {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      itemCount: displayedForums.length,
                      itemBuilder: (_, index) => ForumCard(
                        item: displayedForums[index],
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully ${displayedForums[index].title}'),
                            ),
                          );
                        }
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 24),
                    );
                  }
                  return Center(
                    child: Text("berhasil"),
                  );
                }
              },
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForumFormPage()),
          );
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}