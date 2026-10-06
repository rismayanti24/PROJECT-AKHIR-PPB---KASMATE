import 'package:flutter/material.dart';

class SkorBadge extends StatelessWidget {
  final int skor;

  const SkorBadge({super.key, required this.skor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skorTampil = skor.clamp(0, 100);

    final (label, warnaLatar, warnaTeks) = switch (skorTampil) {
      >= 80 => (
        'Disiplin',
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      >= 60 => (
        'Cukup',
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
      ),
      _ => (
        'Perlu Ditingkatkan',
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$skorTampil/100 · $label',
        style: TextStyle(
          color: warnaTeks,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
