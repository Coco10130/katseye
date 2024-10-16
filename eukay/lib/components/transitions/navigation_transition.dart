import 'package:flutter/material.dart';

void navigateWithSlideTransition({
  required BuildContext context,
  required Widget page,
  Offset beginOffset = const Offset(2.0, 0.0),
  Offset endOffset = Offset.zero,
  Curve curve = Curves.fastEaseInToSlowEaseOut,
  Duration duration = const Duration(milliseconds: 500),
  VoidCallback? onFetch,
}) async {
  final result = await Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: beginOffset, end: endOffset).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );

  if (result != null && result == true) {
    onFetch?.call();
  }
}
