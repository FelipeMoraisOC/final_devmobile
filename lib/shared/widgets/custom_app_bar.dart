import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      title: Text(
        'Final!',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppThemeConstants.textDark,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Light\nTheme',
              textAlign: TextAlign.right,
              style:
                  themeProvider.isDarkMode
                      ? const TextStyle(
                        fontSize: 12,
                        color: AppThemeConstants.textLight,
                      )
                      : const TextStyle(
                        fontSize: 12,
                        color: AppThemeConstants.textDark,
                      ),
            ),
            const SizedBox(width: 8),
            CupertinoSwitch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeTrackColor: AppThemeConstants.backgroundLight,
              inactiveTrackColor: AppThemeConstants.textLight,
              inactiveThumbColor: AppThemeConstants.backgroundLight,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
