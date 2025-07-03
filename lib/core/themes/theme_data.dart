import 'package:flutter/material.dart';

class FadeSlideFromBottomLeftBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // animação de posição: de (-1, 1) até (0,0)
    final offsetAnim = Tween<Offset>(
      begin: const Offset(-1.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

    // animação de opacidade
    final fadeAnim = CurvedAnimation(parent: animation, curve: Curves.easeIn);

    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(position: offsetAnim, child: child),
    );
  }
}

final myPageTransitions = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeSlideFromBottomLeftBuilder(),
    TargetPlatform.iOS: FadeSlideFromBottomLeftBuilder(),
    TargetPlatform.windows: FadeSlideFromBottomLeftBuilder(),
    TargetPlatform.macOS: FadeSlideFromBottomLeftBuilder(),
    TargetPlatform.linux: FadeSlideFromBottomLeftBuilder(),
  },
);
