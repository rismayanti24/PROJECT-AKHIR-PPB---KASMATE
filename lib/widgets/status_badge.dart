import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'lunas':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Lunas';
        break;
      case 'menunggu':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        label = 'Menunggu';
        break;
      case 'belum':
      default:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        label = 'Belum Bayar';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
