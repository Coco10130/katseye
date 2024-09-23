import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:eukay/pages/search/ui/searched_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            controller: searchController,
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
                final prompt = searchController.text;
                if (prompt.isNotEmpty) {
                  context.read<SearchBloc>().add(FetchSearchedProductEvent(
                      searchPrompt: searchController.text));
                  navigateWithSlideTransition(
                      context: context,
                      page: SearchedPage(searchPrompt: searchController.text));
                }
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
