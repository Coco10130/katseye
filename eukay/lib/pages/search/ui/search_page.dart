import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/search/ui/searched_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              hintText: "Search Product",
              hintStyle: const TextStyle(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                navigateWithSlideTransition(
                    context: context, page: const SearchedPage());
              },
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
