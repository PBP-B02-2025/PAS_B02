import 'package:flutter/material.dart';

class ForumToolbar extends StatelessWidget {
  final String activeFilter;
  final String sortValue;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSortChanged;

  const ForumToolbar({
    super.key,
    required this.activeFilter,
    required this.sortValue,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 36;

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // FILTER
          Container(
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _btn("All", activeFilter == "all", () {
                  onFilterChanged("all");
                }),
                _btn("My Forums", activeFilter == "mine", () {
                  onFilterChanged("mine");
                }),
              ],
            ),
          ),

          const Spacer(),

          // SORT
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortValue,
                items: const [
                  DropdownMenuItem(value: "newest", child: Text("Newest")),
                  DropdownMenuItem(value: "oldest", child: Text("Oldest")),
                  DropdownMenuItem(value: "popular", child: Text("Popular")),
                ],
                onChanged: (value) {
                  onSortChanged(value!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
