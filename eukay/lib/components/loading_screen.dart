import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  final Color color;
  const LoadingScreen({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.twoRotatingArc(color: color, size: 50),
    );
  }
}
