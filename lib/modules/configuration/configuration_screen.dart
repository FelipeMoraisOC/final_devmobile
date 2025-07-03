import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:final_devmobile/shared/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // Exemplo de 10 itens
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Configurações',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tema do Aplicativo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Light\nTheme',
                              textAlign: TextAlign.right,
                              style:
                                  themeProvider.isDarkMode
                                      ? const TextStyle(
                                        fontSize: 12,
                                        color: AppThemeConstants.textDark,
                                      )
                                      : const TextStyle(
                                        fontSize: 12,
                                        color: AppThemeConstants.textLight,
                                      ),
                            ),
                            const SizedBox(width: 8),
                            CupertinoSwitch(
                              value: isDark,
                              onChanged: (value) {
                                themeProvider.toggleTheme(value);
                              },
                              activeTrackColor:
                                  AppThemeConstants.backgroundLight,
                              inactiveTrackColor: AppThemeConstants.textLight,
                              inactiveThumbColor:
                                  AppThemeConstants.backgroundLight,
                              thumbColor: AppThemeConstants.textLight,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dark\nMode',
                              textAlign: TextAlign.left,
                              style:
                                  themeProvider.isDarkMode
                                      ? const TextStyle(
                                        fontSize: 12,
                                        color: AppThemeConstants.textDark,
                                      )
                                      : const TextStyle(
                                        fontSize: 12,
                                        color: AppThemeConstants.textLight,
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
