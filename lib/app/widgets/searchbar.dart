import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.searchController,
    this.onChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final box = GetStorage(); // Initialize GetStorage
  final FocusNode focusNode = FocusNode(); // FocusNode to track focus state
  List<String> searchHistory = [];
  bool showHistory = false; // Controls visibility of search history

  @override
  void initState() {
    super.initState();
    // Load search history from storage
    searchHistory = box.read<List<dynamic>>('searchHistory')?.cast<String>() ?? [];

    // Add listener to the focus node
    focusNode.addListener(() {
      setState(() {
        showHistory = focusNode.hasFocus; // Show history only when focused
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  void addToSearchHistory(String query) {
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.add(query);
      });
      box.write('searchHistory', searchHistory); // Save updated history to storage
    }
  }

  void clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
    box.remove('searchHistory'); // Clear history from storage
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: widget.searchController,
            focusNode: focusNode, // Attach the focus node
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.searchController.clear();
                  if (widget.onChanged != null) widget.onChanged!('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            onChanged: widget.onChanged,
            onSubmitted: (query) {
              addToSearchHistory(query); // Add query to history on submission
              if (widget.onChanged != null) widget.onChanged!(query);
            },
          ),
        ),
        if (showHistory && searchHistory.isNotEmpty) // Show history only when focused
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search History',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8.0,
                  children: searchHistory.map((query) {
                    return GestureDetector(
                      onTap: () {
                        widget.searchController.text = query;
                        if (widget.onChanged != null) widget.onChanged!(query);
                      },
                      child: Chip(
                        label: Text(query),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            searchHistory.remove(query);
                          });
                          box.write('searchHistory', searchHistory); // Update storage
                        },
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: clearSearchHistory,
                    child: const Text('Clear History'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}