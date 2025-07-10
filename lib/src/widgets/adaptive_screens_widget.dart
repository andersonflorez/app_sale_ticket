import 'package:flutter/material.dart';

class AdaptiveScreensWidget extends StatelessWidget {
  const AdaptiveScreensWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      // Mobile layout
      return child;
    } else {
      // Tablet layout
      return Center(
        child: SizedBox(
          width: 600,
          child: child,
        ),
      );
    }
  }
}
