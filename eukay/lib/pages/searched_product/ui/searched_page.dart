import 'package:eukay/components/my_searchbox.dart';
import 'package:flutter/material.dart';

class SearchedPage extends StatelessWidget {
  const SearchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: MySeach(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: 8,
            label: "Searched product",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
