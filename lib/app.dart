import 'package:final_devmobile/core/routes.dart';
import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:final_devmobile/modules/auth/login_screen.dart';
import 'package:final_devmobile/modules/auth/register_screen.dart';
import 'package:final_devmobile/modules/categoria/categoria_screen.dart';
import 'package:final_devmobile/modules/configuration/configuration_screen.dart';
import 'package:final_devmobile/modules/home/home_screen.dart';
import 'package:final_devmobile/modules/montagem_lista/montagem_lista_screen.dart';
import 'package:final_devmobile/modules/onboarding/onboarding_screen.dart';
import 'package:final_devmobile/modules/produto/produto_screen.dart';
import 'package:final_devmobile/shared/splash_screen.dart';
import 'package:final_devmobile/shared/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Projeto Final',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      initialRoute: '/',
      navigatorObservers: [routeObserver],
      routes: {
        '/':
            (context) => FutureBuilder<bool>(
              future: SharedPreferencesUtils.isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen(
                    nextRoute: '/onboarding',
                    lottiePath: 'assets/animations/splash_animation.json',
                  );
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return HomeScreen();
                } else {
                  return OnboardingScreen(loginRoute: '/login');
                }
              },
            ),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/configuration': (context) => ConfigurationScreen(),
        '/produto': (context) => ProdutoScreen(),
        '/categoria': (context) => CategoriaScreen(),
        'montagem_lista': (context) => MontagemListaScreen(),
        '/onboarding':
            (context) => const OnboardingScreen(loginRoute: '/login'),
      },
    );
  }
}
