import 'package:flutter/material.dart';
import '../utils/format.dart';
import 'status_badge.dart';
import 'member_tile.dart';

class DetailTagihan extends StatelessWidget {
  final String judul;
  final int total;
  final String tanggal;
  final String jatuhTempo;
  final List<Map<String, dynamic>> daftarPembagian;
  final String status;

  const DetailTagihan({
    super.key,
    required this.judul,
    required this.total,
    required this.tanggal,
    required this.jatuhTempo,
    required this.daftarPembagian,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          formatRupiah(total),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'Tanggal: $tanggal',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.event_busy, size: 14, color: Colors.redAccent),
            const SizedBox(width: 4),
            Text(
              'Jatuh Tempo: $jatuhTempo',
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Pembagian Tagihan:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...daftarPembagian.map((item) {
          return MemberTile(
            nama: item['nama'] as String,
            nominal: item['nominal'] as int,
            status: item['status'] as String,
          );
        }),
      ],
    );
  }
}
