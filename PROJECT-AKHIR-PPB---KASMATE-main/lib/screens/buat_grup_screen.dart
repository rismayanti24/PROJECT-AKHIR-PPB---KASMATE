import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/kas_store.dart';

class BuatGrupScreen extends StatefulWidget {
  const BuatGrupScreen({super.key});

  @override
  State<BuatGrupScreen> createState() => _BuatGrupScreenState();
}

class _BuatGrupScreenState extends State<BuatGrupScreen> {
  final TextEditingController _namaGrupController = TextEditingController();
  late final String _inviteCode;

  @override
  void initState() {
    super.initState();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    final acak =
        List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
    _inviteCode = 'KM26-$acak';
  }

  @override
  void dispose() {
    _namaGrupController.dispose();
    super.dispose();
  }

  String get _inviteLink => 'https://kasmate.app/join/$_inviteCode';

  Future<void> _simpanDanBagikanWa({required bool bukaWa}) async {
    if (_namaGrupController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama grup terlebih dahulu')),
      );
      return;
    }

    final grup = kasStore.buatGrupBaru(_namaGrupController.text, _inviteCode);

    if (bukaWa) {
      await kasStore.bagikanUndanganGrupWhatsApp(grup);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Grup "${grup.namaGrup}" (${grup.kodeUndangan}) berhasil dibuat!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Buat grup baru',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Jadi bendahara & bagikan link undangan ke anggota',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nama grup',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _namaGrupController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Kas Kos 3A',
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kode undangan grup',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _inviteCode,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Color(0xFF074E3B),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy_outlined,
                            color: Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                  text: '$_inviteCode ($_inviteLink)'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kode & link undangan disalin'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFE5E7EB)),
                    const Text(
                      'Link undangan otomatis',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _inviteLink,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _simpanDanBagikanWa(bukaWa: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF074E3B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.share_outlined, size: 19),
                label: const Text(
                  'Buat grup & Bagikan ke WhatsApp',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: OutlinedButton(
                  onPressed: () => _simpanDanBagikanWa(bukaWa: false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: const Color(0xFF111827),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Buat grup saja',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
