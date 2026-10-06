import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, themeMode, child) {
          return SwitchListTile(
            title: const Text('Mode Gelap'),
            value: themeMode == ThemeMode.dark,
            onChanged: (isDarkMode) => toggleThemeMode(),
          );
        },
      ),
    );
  }
}
