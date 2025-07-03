import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final String animationPath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool autoPlay;
  final AnimationController? controller;
  final Function()? onAnimationComplete;

  const LottieWidget({
    Key? key,
    required this.animationPath,
    this.width,
    this.height,
    this.repeat = true,
    this.autoPlay = true,
    this.controller,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animationPath,
      width: width,
      height: height,
      repeat: repeat,
      animate: autoPlay,
      controller: controller,
      onLoaded: (composition) {
        // Se houver um controlador e um callback para quando a animação completar
        if (controller != null && onAnimationComplete != null) {
          controller!.duration = composition.duration;
          controller!.forward().whenComplete(onAnimationComplete!);
        }
      },
    );
  }
}
