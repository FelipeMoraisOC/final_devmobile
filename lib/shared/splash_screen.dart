import 'package:final_devmobile/shared/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;
  final Duration duration;
  final String lottiePath;

  const SplashScreen({
    Key? key,
    required this.nextRoute,
    this.duration = const Duration(seconds: 3),
    required this.lottiePath,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Alternativa: Se preferir usar um temporizador em vez de depender da duração da animação
    // Future.delayed(widget.duration, () {
    //   _navigateToNextScreen();
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: LottieWidget(
          animationPath: widget.lottiePath,
          controller: _controller,
          repeat: false,
          autoPlay: true,
          onAnimationComplete: _navigateToNextScreen,
        ),
      ),
    );
  }
}
