import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../data/kas_store.dart';
import '../data/profil_store.dart';

class BayarTagihanScreen extends StatefulWidget {
  final bool showBackButton;
  const BayarTagihanScreen({super.key, this.showBackButton = true});

  @override
  State<BayarTagihanScreen> createState() => _BayarTagihanScreenState();
}

class _BayarTagihanScreenState extends State<BayarTagihanScreen> {
  String? _selectedAnggotaId;
  XFile? _buktiFoto;
  final ImagePicker _picker = ImagePicker();

  static const Color _primaryGreen = Color(0xFF074E3B);

  Future<void> _pilihSumberFoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unggah bukti transfer',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih foto struk/screenshot transfer dari perangkat kamu',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: _primaryGreen),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(ctx);
                final file = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (file != null && mounted) {
                  setState(() => _buktiFoto = file);
                }
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.camera_alt_outlined, color: _primaryGreen),
              title: const Text('Ambil Foto Kamera'),
              onTap: () async {
                Navigator.pop(ctx);
                final file = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (file != null && mounted) {
                  setState(() => _buktiFoto = file);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KasRootState>(
      valueListenable: kasStore,
      builder: (context, rootState, _) {
        final state = rootState.grupAktif;
        final belumBayarList =
            state.anggota.where((a) => a.status != StatusBayar.lunas).toList();

        final AnggotaKas? aktif = belumBayarList.isEmpty
            ? null
            : belumBayarList.firstWhere(
                (a) => a.id == _selectedAnggotaId,
                orElse: () => belumBayarList.first,
              );

        final tagihanAktif =
            state.daftarTagihan.isNotEmpty ? state.daftarTagihan.first : null;
        final totalTagihan = aktif?.tagihan ?? 0;
        final bagianPajak = (totalTagihan * 0.09).round();
        final bagianItem = totalTagihan - bagianPajak;

        final profil = profilNotifier.value;
        final bankTujuan = profil.bank.isEmpty ? 'BCA' : profil.bank;
        final rekTujuan =
            profil.noRekening.isEmpty ? '8820 1122 33' : profil.noRekening;
        final namaPenerima =
            profil.nama.isEmpty ? state.bendahara : profil.nama;

        final bisaKirim = aktif != null && _buktiFoto != null;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAFAFA),
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: widget.showBackButton,
            iconTheme: const IconThemeData(color: Color(0xFF111827)),
            title: const Text(
              'Tagihan saya',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (belumBayarList.isNotEmpty) ...[
                    const Text(
                      'Bayar sebagai anggota:',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: belumBayarList.map((a) {
                          final selected = aktif?.id == a.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(a.nama),
                              selected: selected,
                              selectedColor: const Color(0xFFDCFCE7),
                              onSelected: (_) {
                                setState(() {
                                  _selectedAnggotaId = a.id;
                                  _buktiFoto = null;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tagihanAktif?.judul ?? 'Tidak ada tagihan',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  tagihanAktif?.tanggal ?? 'Semua sudah lunas',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: aktif == null
                                    ? const Color(0xFFDCFCE7)
                                    : aktif.status == StatusBayar.menunggu
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                aktif == null
                                    ? 'Lunas'
                                    : aktif.status == StatusBayar.menunggu
                                        ? 'Menunggu'
                                        : 'Belum bayar',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: aktif == null
                                      ? const Color(0xFF15803D)
                                      : aktif.status == StatusBayar.menunggu
                                          ? const Color(0xFFB45309)
                                          : const Color(0xFFB91C1C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          formatRupiah(totalTagihan),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const Divider(color: Color(0xFFE5E7EB), height: 28),
                        _buildDetailRow(
                          'Bagian item belanja',
                          formatRupiah(bagianItem),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'Bagian pajak',
                          formatRupiah(bagianPajak),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Transfer ke',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$bankTujuan $rekTujuan a.n. $namaPenerima',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy_outlined,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: rekTujuan));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nomor rekening disalin'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: aktif == null ? null : _pilihSumberFoto,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _buktiFoto != null
                            ? const Color(0xFFECFDF5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _buktiFoto != null
                              ? _primaryGreen
                              : const Color(0xFFE5E7EB),
                          width: _buktiFoto != null ? 1.5 : 1,
                        ),
                      ),
                      child: _buktiFoto == null
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 28,
                                    color: _primaryGreen,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Unggah foto bukti transfer (Wajib)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Ketuk untuk memilih dari Galeri atau Kamera',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: kIsWeb
                                      ? Image.network(
                                          _buktiFoto!.path,
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(_buktiFoto!.path),
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: _primaryGreen,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _buktiFoto!.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _primaryGreen,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _pilihSumberFoto,
                                      child: const Text('Ganti foto'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ElevatedButton(
                      onPressed: aktif == null
                          ? null
                          : () {
                              final foto = _buktiFoto;
                              if (foto == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Wajib unggah foto bukti transfer terlebih dahulu!',
                                    ),
                                  ),
                                );
                                return;
                              }

                              kasStore.ajukanPembayaran(
                                anggotaId: aktif.id,
                                namaFileBukti: foto.name,
                                buktiPath: foto.path,
                              );
                              setState(() => _buktiFoto = null);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Bukti transfer ${aktif.nama} dikirim ke bendahara untuk diverifikasi!',
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            bisaKirim ? _primaryGreen : const Color(0xFF9CA3AF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        bisaKirim
                            ? 'Tandai sudah bayar'
                            : 'Unggah bukti dulu untuk mengirim',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
