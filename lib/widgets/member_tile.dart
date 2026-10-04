import 'package:flutter/material.dart';
import '../utils/format.dart';
import 'status_badge.dart';

class MemberTile extends StatelessWidget {
  final String nama;
  final int nominal;
  final String status;

  const MemberTile({
    super.key,
    required this.nama,
    required this.nominal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: status),
              ],
            ),
          ),
          Text(
            formatRupiah(nominal),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
