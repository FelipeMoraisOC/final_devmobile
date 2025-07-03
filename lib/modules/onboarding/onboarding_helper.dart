import 'package:final_devmobile/shared/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingHelper {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Verificar se o usuário já viu o onboarding
  static Future<bool> hasSeenOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  // Marcar que o usuário já viu o onboarding
  static Future<void> markOnboardingAsSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  // Método para decidir qual rota inicial mostrar
  static Future<String> getInitialRoute() async {
    bool hasSeenOnboarding = await OnboardingHelper.hasSeenOnboarding();

    // Sempre mostrar a splash screen primeiro
    String initialRoute = '/';

    // Configurar a próxima rota após a splash screen
    // Se o usuário já viu o onboarding, vai direto para o login
    // Caso contrário, mostra o onboarding
    if (hasSeenOnboarding) {
      SplashScreen.setNextRoute('/login');
    } else {
      SplashScreen.setNextRoute('/onboarding');
    }

    return initialRoute;
  }
}

// Atualização na classe SplashScreen para permitir configuração dinâmica da próxima rota
class SplashScreen extends StatefulWidget {
  static String _nextRoute = '/onboarding';
  final Duration duration;
  final String lottiePath;

  const SplashScreen({
    Key? key,
    this.duration = const Duration(seconds: 3),
    required this.lottiePath,
  }) : super(key: key);

  static void setNextRoute(String route) {
    _nextRoute = route;
  }

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacementNamed(SplashScreen._nextRoute);
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

// Importando a classe LottieWidget para não quebrar o código
