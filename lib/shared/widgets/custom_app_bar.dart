import 'package:final_devmobile/core/constants.dart';
import 'package:final_devmobile/core/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  // ignore: overridden_fields
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      title: Text(
        'FMCList',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: AppThemeConstants.textDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
