import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final double height;
  final bool isScrollable;
  const MyTabBar(
      {super.key,
      required this.tabs,
      this.height = kToolbarHeight,
      this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: SizedBox(
        height: height,
        child: TabBar(
          tabs: tabs,
          isScrollable: isScrollable,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSecondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
