import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final double height;
  const MyTabBar({super.key, required this.tabs, this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: SizedBox(
        height: height,
        child: TabBar(
          tabs: tabs,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
