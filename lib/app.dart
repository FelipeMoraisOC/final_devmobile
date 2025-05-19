import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:final_devmobile/modules/auth/register_screen.dart';
import 'package:final_devmobile/modules/home/home_screen.dart';
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
      routes: {
        '/': (context) => RegisterScreen(),
        // '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
