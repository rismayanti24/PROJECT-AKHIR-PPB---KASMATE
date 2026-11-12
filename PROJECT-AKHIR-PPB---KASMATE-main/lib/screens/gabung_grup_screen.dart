import 'package:flutter/material.dart';
import '../data/kas_store.dart';

class GabungGrupScreen extends StatefulWidget {
  const GabungGrupScreen({super.key});

  @override
  State<GabungGrupScreen> createState() => _GabungGrupScreenState();
}

class _GabungGrupScreenState extends State<GabungGrupScreen> {
  final TextEditingController _kodeController =
      TextEditingController(text: 'TIB2-9M3K');

  @override
  void dispose() {
    _kodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grupCocok = kasStore.cariGrupByKode(_kodeController.text);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Gabung ke grup',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masukkan kode undangan valid dari bendahara',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Kode undangan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _kodeController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Contoh: KS2B-7X4Q atau TIB2-9M3K',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF074E3B),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Status Validasi Real-time
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: grupCocok != null
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: grupCocok != null
                        ? const Color(0xFFA7F3D0)
                        : const Color(0xFFFECACA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          grupCocok != null
                              ? Icons.check_circle_rounded
                              : Icons.error_outline_rounded,
                          size: 18,
                          color: grupCocok != null
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB91C1C),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            grupCocok != null
                                ? '${grupCocok.namaGrup} • ${grupCocok.anggota.length} anggota'
                                : 'Kode grup tidak ditemukan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: grupCocok != null
                                  ? const Color(0xFF074E3B)
                                  : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (grupCocok != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Bendahara: ${grupCocok.bendahara}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Grup tersedia untuk uji coba:',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: kasStore.daftarGrup.map((g) {
                  return ActionChip(
                    label: Text('${g.namaGrup} (${g.kodeUndangan})'),
                    onPressed: () {
                      setState(() {
                        _kodeController.text = g.kodeUndangan;
                      });
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: grupCocok == null
                      ? null
                      : () {
                          final sukses =
                              kasStore.gabungGrup(_kodeController.text);
                          if (sukses) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Berhasil bergabung ke ${grupCocok.namaGrup}!',
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF074E3B),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Gabung grup',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
