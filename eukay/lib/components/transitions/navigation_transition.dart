import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

void navigateWithSlideTransition({
  required BuildContext context,
  required Widget page,
  Offset beginOffset = const Offset(2.0, 0.0),
  Offset endOffset = Offset.zero,
  Curve curve = Curves.fastEaseInToSlowEaseOut,
  Duration duration = const Duration(milliseconds: 500),
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondAnimation) => page,
      transitionsBuilder: (context, animation, secondAimation, child) {
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
}
